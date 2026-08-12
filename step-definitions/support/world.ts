import { setWorldConstructor, World, IWorldOptions, After, Before, setDefaultTimeout } from '@cucumber/cucumber';

setDefaultTimeout(35_000);
import { AxiosInstance } from 'axios';
import { WebDriver } from 'selenium-webdriver';
import { createApiClient } from './api-client';
import { quitDriver, takeScreenshot } from './driver';

export interface EcomWorld extends World {
  api: AxiosInstance;
  driver: WebDriver | null;
  lastResponse: import('axios').AxiosResponse | null;
  token: string | null;
  context: Record<string, unknown>;
}

class EcomWorldImpl extends World implements EcomWorld {
  api = createApiClient();
  driver: WebDriver | null = null;
  lastResponse: import('axios').AxiosResponse | null = null;
  token: string | null = null;
  context: Record<string, unknown> = {};

  constructor(options: IWorldOptions) {
    super(options);
  }
}

setWorldConstructor(EcomWorldImpl);

After({ tags: '@ui' }, async function (this: EcomWorld, scenario) {
  if (scenario.result?.status === 'FAILED') {
    await takeScreenshot(scenario.pickle.name.replace(/\s+/g, '_'));
  }
  await quitDriver();
});

Before(function (this: EcomWorld) {
  this.lastResponse = null;
  this.context = {};
});
