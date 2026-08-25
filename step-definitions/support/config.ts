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

function env(name: string, fallback = ''): string {
  return (process.env[name] ?? fallback).trim();
}

export const config = {
  get apiGatewayUrl() { return env('API_GATEWAY_URL', 'https://digi-cart-api-gateway-dev-wdbieowaja-ue.a.run.app'); },
  get platformUiUrl() { return env('PLATFORM_UI_URL', 'https://digi-cart-platform-ui-dev-wdbieowaja-ue.a.run.app'); },
  get adminUiUrl() { return env('ADMIN_UI_URL', 'https://digi-cart-merchant-ui-dev-wdbieowaja-ue.a.run.app'); },
  get storefrontUrl() { return env('STOREFRONT_URL', 'https://digi-cart-storefront-dev-wdbieowaja-ue.a.run.app/s/test-store'); },
  get jwtSecret() { return env('JWT_SECRET') || env('E2E_JWT_SECRET'); },
  get browser() { return (env('BROWSER', 'chrome') || 'chrome') as 'chrome' | 'firefox' | 'edge'; },
  get headless() { return process.env.HEADLESS !== 'false'; },
  credentials: {
    get superadmin() {
      return {
        email: env('E2E_SUPERADMIN_EMAIL', 'superadmin@ecom.app'),
        password: env('E2E_SUPERADMIN_PASSWORD'),
      };
    },
    get admin() {
      return {
        email: env('E2E_ADMIN_EMAIL'),
        password: env('E2E_ADMIN_PASSWORD'),
      };
    },
    get user() {
      return {
        email: env('E2E_USER_EMAIL'),
        password: env('E2E_USER_PASSWORD'),
      };
    },
  },
};
