const fs = require('fs');

const title = process.argv[2] || 'Test Results';
const reportPath = process.argv[3] || 'reports/cucumber-report.json';
const outPath = process.env.GITHUB_STEP_SUMMARY;

function scenarioStatus(steps) {
  const statuses = (steps || []).map((st) => st.result && st.result.status).filter(Boolean);
  if (statuses.includes('failed')) return 'failed';
  if (statuses.length && statuses.every((s) => s === 'passed')) return 'passed';
  if (statuses.includes('passed') && statuses.every((s) => s === 'passed' || s === 'skipped')) return 'passed';
  return 'skipped';
}

if (!fs.existsSync(reportPath)) {
  const missing = `## ${title}\n\nNo Cucumber report found at \`${reportPath}\`.\n`;
  if (outPath) fs.appendFileSync(outPath, missing);
  else process.stdout.write(missing);
  process.exit(0);
}

const data = JSON.parse(fs.readFileSync(reportPath, 'utf8'));
let pass = 0;
let fail = 0;
let skip = 0;
const failed = [];

for (const feature of data) {
  for (const scenario of feature.elements || []) {
    if (scenario.type === 'background') continue;
    const status = scenarioStatus(scenario.steps);
    if (status === 'failed') {
      fail += 1;
      failed.push(`- **${feature.name}** › ${scenario.name}`);
    } else if (status === 'passed') {
      pass += 1;
    } else {
      skip += 1;
    }
  }
}

const total = pass + fail + skip;
const icon = fail === 0 ? '✅' : '❌';
const lines = [
  `## ${icon} ${title}`,
  '| Passed | Failed | Skipped | Total |',
  '|--------|--------|---------|-------|',
  `| ${pass} | ${fail} | ${skip} | ${total} |`,
];

if (failed.length) {
  lines.push('', '### Failed Scenarios', ...failed);
}

const markdown = `${lines.join('\n')}\n`;
if (outPath) fs.appendFileSync(outPath, markdown);
else process.stdout.write(markdown);
