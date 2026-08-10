import * as dotenv from 'node:fs';
import path from 'node:path';

function loadEnv() {
  const envFile = path.join(__dirname, '../../.env');
  try {
    const lines = require('node:fs').readFileSync(envFile, 'utf8').split('\n');
    for (const line of lines) {
      const trimmed = line.trim();
      if (!trimmed || trimmed.startsWith('#')) continue;
      const [key, ...rest] = trimmed.split('=');
      if (key && !(key in process.env)) {
        process.env[key] = rest.join('=');
      }
    }
  } catch {
    // .env not present — rely on environment variables set externally
  }
}

loadEnv();

export const config = {
  apiGatewayUrl: process.env.API_GATEWAY_URL || 'https://ecom-api-gateway-m6jmogmpra-ue.a.run.app',
  platformUiUrl: process.env.PLATFORM_UI_URL || 'https://ecom-platform-ui-m6jmogmpra-ue.a.run.app',
  adminUiUrl:    process.env.ADMIN_UI_URL    || 'https://ecom-admin-ui-m6jmogmpra-ue.a.run.app',
  storefrontUrl: process.env.STOREFRONT_URL  || 'https://ecom-storefront-m6jmogmpra-ue.a.run.app',
  jwtSecret:     process.env.JWT_SECRET      || '',
  browser:       (process.env.BROWSER        || 'chrome') as 'chrome' | 'firefox' | 'edge',
  headless:      process.env.HEADLESS !== 'false',
  credentials: {
    superadmin: {
      email:    process.env.E2E_SUPERADMIN_EMAIL    || 'superadmin@ecom.app',
      password: process.env.E2E_SUPERADMIN_PASSWORD || '',
    },
    admin: {
      email:    process.env.E2E_ADMIN_EMAIL    || '',
      password: process.env.E2E_ADMIN_PASSWORD || '',
    },
    user: {
      email:    process.env.E2E_USER_EMAIL    || '',
      password: process.env.E2E_USER_PASSWORD || '',
    },
  },
};
