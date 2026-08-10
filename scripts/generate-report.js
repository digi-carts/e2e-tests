const reporter = require('multiple-cucumber-html-reporter');
const path = require('path');
const fs = require('fs');

const reportJson = path.join(__dirname, '../reports/cucumber-report.json');
if (!fs.existsSync(reportJson)) {
  console.error('No cucumber-report.json found. Run tests first.');
  process.exit(1);
}

reporter.generate({
  jsonDir: path.join(__dirname, '../reports'),
  reportPath: path.join(__dirname, '../reports/html-report'),
  metadata: {
    browser: { name: process.env.BROWSER || 'chrome', version: 'latest' },
    device: 'CI',
    platform: { name: 'linux', version: 'ubuntu-latest' },
  },
  customData: {
    title: 'ecom E2E Test Results',
    data: [
      { label: 'Project', value: 'dcart platform' },
      { label: 'Target', value: process.env.API_GATEWAY_URL || 'https://ecom-api-gateway-m6jmogmpra-ue.a.run.app' },
      { label: 'Run date', value: new Date().toISOString() },
    ],
  },
});

console.log('HTML report generated at reports/html-report/index.html');
