import { Given, When, Then } from '@cucumber/cucumber';
import { By, until } from 'selenium-webdriver';
import assert from 'node:assert/strict';
import { EcomWorld } from '../support/world';
import { getDriver, navigateTo, takeScreenshot } from '../support/driver';
import { config } from '../support/config';

// ─── Navigation ───────────────────────────────────────────────────────────────

Given('I open the platform UI', async function (this: EcomWorld) {
  await navigateTo(config.platformUiUrl);
});

Given('I open the admin UI', async function (this: EcomWorld) {
  await navigateTo(config.adminUiUrl);
});

Given('I open the storefront', async function (this: EcomWorld) {
  await navigateTo(config.storefrontUrl);
});

When('I navigate to the products page', async function (this: EcomWorld) {
  const d = await getDriver();
  const currentUrl = await d.getCurrentUrl();
  const u = new URL(currentUrl);
  const storeMatch = u.pathname.match(/^(\/s\/[^/]+)/);
  const productsPath = storeMatch ? `${storeMatch[1]}/products` : '/products';
  await d.get(`${u.origin}${productsPath}`);
});

// ─── Page assertions ──────────────────────────────────────────────────────────

Then('the page title should contain {string}', async function (this: EcomWorld, text: string) {
  const d = await getDriver();
  await d.wait(async () => {
    const title = await d.getTitle();
    return title.toLowerCase().includes(text.toLowerCase());
  }, 18_000, `Page title did not contain "${text}"`);
});

Then('the page should load without errors', async function (this: EcomWorld) {
  const d = await getDriver();
  const source = await d.getPageSource();
  // Check for common runtime error indicators (exclude Next.js RSC embedded notFound fallback)
  const errorPatterns = ['Application error', 'Internal Server Error', '500 -'];
  for (const pattern of errorPatterns) {
    assert.ok(!source.includes(pattern), `Page contains error: "${pattern}"`);
  }
});

Then('the page should not show a 500 error', async function (this: EcomWorld) {
  const d = await getDriver();
  const title = await d.getTitle();
  assert.ok(!title.includes('500'), 'Page title shows 500 error');
  const source = await d.getPageSource();
  assert.ok(!source.includes('Internal Server Error'), 'Page shows Internal Server Error');
});

Then('I should see an email input field', async function (this: EcomWorld) {
  const d = await getDriver();
  const emailField = await d.wait(
    until.elementLocated(By.css('input[type="email"], input[name="email"], input[placeholder*="email" i]')),
    18_000,
    'Email input not found'
  );
  assert.ok(await emailField.isDisplayed(), 'Email input is not visible');
});

Then('I should see a password input field', async function (this: EcomWorld) {
  const d = await getDriver();
  const passField = await d.wait(
    until.elementLocated(By.css('input[type="password"]')),
    18_000,
    'Password input not found'
  );
  assert.ok(await passField.isDisplayed(), 'Password input is not visible');
});

Then('I should see a login button', async function (this: EcomWorld) {
  const d = await getDriver();
  const btn = await d.wait(
    until.elementLocated(By.css('button[type="submit"]')),
    18_000,
    'Login button not found'
  );
  assert.ok(await btn.isDisplayed(), 'Login button is not visible');
});

Then('I should see a navigation element on the page', async function (this: EcomWorld) {
  const d = await getDriver();
  const nav = await d.wait(
    until.elementLocated(By.css('nav, header, [role="navigation"]')),
    18_000,
    'Navigation element not found'
  );
  assert.ok(await nav.isDisplayed(), 'Navigation element is not visible');
});

Then('I should see storefront navigation or a store status message', async function (this: EcomWorld) {
  const d = await getDriver();
  await d.wait(async () => {
    const source = await d.getPageSource();
    const hydratedNav = /<(nav|header)\b/i.test(source) || /role=["']navigation["']/i.test(source);
    const storeStatus = /Store not found|Store temporarily unavailable/i.test(source);
    return hydratedNav || storeStatus;
  }, 25_000, 'Storefront did not show navigation or a store status message');
});

Then('I should see an error message on the page', async function (this: EcomWorld) {
  const d = await getDriver();
  // Wait up to 8s for an error to appear
  await d.wait(async () => {
    const source = await d.getPageSource();
    return (
      source.toLowerCase().includes('invalid') ||
      source.toLowerCase().includes('incorrect') ||
      source.toLowerCase().includes('wrong') ||
      source.toLowerCase().includes('error') ||
      source.toLowerCase().includes('failed')
    );
  }, 8_000, 'No error message appeared after invalid login');
});

Then('I should be redirected to the dashboard', async function (this: EcomWorld) {
  const d = await getDriver();
  await d.wait(async () => {
    const url = await d.getCurrentUrl();
    return url.includes('/dashboard') || url.includes('/overview') || url.includes('/home');
  }, 30_000, 'Did not redirect to dashboard');
});

Then('I should be redirected to the admin dashboard', async function (this: EcomWorld) {
  const d = await getDriver();
  await d.wait(async () => {
    const url = await d.getCurrentUrl();
    return !url.includes('/login');
  }, 30_000, 'Still on login page after successful login');
});

Then('I should see the dashboard heading', async function (this: EcomWorld) {
  const d = await getDriver();
  const heading = await d.wait(
    until.elementLocated(By.css('h1, h2, [data-testid="dashboard-heading"]')),
    18_000,
    'Dashboard heading not found'
  );
  assert.ok(await heading.isDisplayed(), 'Dashboard heading is not visible');
});

Then('I should see the heading {string}', async function (this: EcomWorld, text: string) {
  const d = await getDriver();
  const heading = await d.wait(
    until.elementLocated(By.xpath(`//h1[contains(normalize-space(.), "${text}")] | //h2[contains(normalize-space(.), "${text}")]`)),
    30_000,
    `Heading "${text}" not found`
  );
  assert.ok(await heading.isDisplayed(), `Heading "${text}" is not visible`);
});

Then('I should see the text {string}', async function (this: EcomWorld, text: string) {
  const d = await getDriver();
  await d.wait(async () => {
    const source = await d.getPageSource();
    return source.includes(text);
  }, 25_000, `Page did not contain text "${text}"`);
});

Then('I should see these dashboard stats with numeric values:', async function (this: EcomWorld, table) {
  const d = await getDriver();
  await d.wait(until.elementLocated(By.css('main [data-slot="card"]')), 30_000, 'Dashboard stat cards not found');

  const labels = (table.raw() as string[][]).map((row) => row[0]).filter(Boolean);
  for (const label of labels) {
    await d.wait(async () => {
      const cards = await d.findElements(By.css('main [data-slot="card"]'));
      for (const card of cards) {
        const cardText = await card.getText();
        if (!cardText.includes(label)) continue;
        const valueEls = await card.findElements(By.css('p.text-3xl, p.font-bold'));
        if (!valueEls.length) continue;
        const value = (await valueEls[0].getText()).trim().replace(/,/g, '');
        if (/^\d+(\.\d+)?$/.test(value)) return true;
      }
      return false;
    }, 30_000, `Dashboard card "${label}" did not show a numeric value`);
  }
});

Then('I should see the store management heading', async function (this: EcomWorld) {
  const d = await getDriver();
  await d.wait(
    until.elementLocated(By.css('h1, h2, [data-testid*="store"], [data-testid*="dashboard"]')),
    18_000,
    'Store management heading not found'
  );
});

// ─── Login interaction ────────────────────────────────────────────────────────

When('I enter email {string} and password {string}', async function (this: EcomWorld, email: string, password: string) {
  const d = await getDriver();
  const emailField = await d.wait(
    until.elementLocated(By.css('input[type="email"], input[name="email"], input[placeholder*="email" i]')),
    18_000
  );
  await emailField.clear();
  await emailField.sendKeys(email);

  const passField = await d.findElement(By.css('input[type="password"]'));
  await passField.clear();
  await passField.sendKeys(password);
});

When('I enter the super-admin credentials', async function (this: EcomWorld) {
  const { email, password } = config.credentials.superadmin;
  if (!password) throw new Error('E2E_SUPERADMIN_PASSWORD not set');
  const d = await getDriver();
  const emailField = await d.wait(until.elementLocated(By.css('input[type="email"], input[name="email"]')), 18_000);
  await emailField.clear();
  await emailField.sendKeys(email);
  const passField = await d.findElement(By.css('input[type="password"]'));
  await passField.clear();
  await passField.sendKeys(password);
});

When('I enter the admin credentials', async function (this: EcomWorld) {
  const { email, password } = config.credentials.admin;
  if (!email || !password) throw new Error('E2E_ADMIN_EMAIL / E2E_ADMIN_PASSWORD not set');
  const d = await getDriver();
  const emailField = await d.wait(until.elementLocated(By.css('input[type="email"], input[name="email"]')), 18_000);
  await emailField.clear();
  await emailField.sendKeys(email);
  const passField = await d.findElement(By.css('input[type="password"]'));
  await passField.clear();
  await passField.sendKeys(password);
});

When('I click the login button', async function (this: EcomWorld) {
  const d = await getDriver();
  const btn = await d.wait(until.elementLocated(By.css('button[type="submit"]')), 18_000);
  await btn.click();
  // Brief wait for navigation or error to settle
  await d.sleep(1500);
});
