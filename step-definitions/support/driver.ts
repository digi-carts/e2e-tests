import { Builder, WebDriver, Browser, By, until, WebElement } from 'selenium-webdriver';
import chrome from 'selenium-webdriver/chrome';
import firefox from 'selenium-webdriver/firefox';
import { config } from './config';

let driver: WebDriver | null = null;

export async function getDriver(): Promise<WebDriver> {
  if (driver) return driver;

  switch (config.browser) {
    case 'firefox': {
      const opts = new firefox.Options();
      if (config.headless) opts.addArguments('--headless');
      driver = await new Builder().forBrowser(Browser.FIREFOX).setFirefoxOptions(opts).build();
      break;
    }
    default: {
      const opts = new chrome.Options();
      if (config.headless) opts.addArguments('--headless=new', '--no-sandbox', '--disable-dev-shm-usage', '--window-size=1280,800');
      else opts.addArguments('--window-size=1280,800');
      driver = await new Builder().forBrowser(Browser.CHROME).setChromeOptions(opts).build();
    }
  }

  await driver.manage().setTimeouts({ implicit: 5000, pageLoad: 30000 });
  return driver;
}

export async function quitDriver(): Promise<void> {
  if (driver) {
    await driver.quit();
    driver = null;
  }
}

export async function navigateTo(url: string): Promise<void> {
  const d = await getDriver();
  await d.get(url);
}

export async function findElement(selector: string): Promise<WebElement> {
  const d = await getDriver();
  return d.findElement(By.css(selector));
}

export async function waitForText(selector: string, text: string, timeoutMs = 10000): Promise<void> {
  const d = await getDriver();
  await d.wait(until.elementTextContains(d.findElement(By.css(selector)), text), timeoutMs);
}

export async function takeScreenshot(name: string): Promise<void> {
  const d = await getDriver();
  const fs = await import('node:fs');
  const path = await import('node:path');
  const dir = path.join(__dirname, '../../reports/screenshots');
  fs.mkdirSync(dir, { recursive: true });
  const data = await d.takeScreenshot();
  fs.writeFileSync(path.join(dir, `${name}-${Date.now()}.png`), data, 'base64');
}
