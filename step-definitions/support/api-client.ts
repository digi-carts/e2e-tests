import axios, { AxiosInstance, AxiosResponse, InternalAxiosRequestConfig } from 'axios';
import { config } from './config';

const RETRY_STATUS = new Set([500, 502, 503, 504]);
const RETRY_METHODS = new Set(['get', 'head', 'options']);
const MAX_RETRIES = 2;

function sleep(ms: number): Promise<void> {
  return new Promise((resolve) => setTimeout(resolve, ms));
}

type RetryConfig = InternalAxiosRequestConfig & { __retries?: number };

export function createApiClient(token?: string): AxiosInstance {
  const instance = axios.create({
    baseURL: config.apiGatewayUrl,
    timeout: 20_000,
    headers: token ? { Authorization: `Bearer ${token}` } : {},
    validateStatus: () => true, // never throw on HTTP errors — let tests assert
  });

  instance.interceptors.response.use(
    async (response) => {
      const cfg = response.config as RetryConfig;
      const method = (cfg.method ?? 'get').toLowerCase();
      const retries = cfg.__retries ?? 0;
      if (RETRY_METHODS.has(method) && RETRY_STATUS.has(response.status) && retries < MAX_RETRIES) {
        cfg.__retries = retries + 1;
        await sleep(1500 * cfg.__retries);
        return instance.request(cfg);
      }
      return response;
    },
    async (error: unknown) => {
      const err = error as { config?: RetryConfig; code?: string; message?: string; response?: unknown };
      const cfg = err.config;
      if (!cfg) return Promise.reject(error);
      const method = (cfg.method ?? 'get').toLowerCase();
      const retries = cfg.__retries ?? 0;
      const retryable =
        !err.response &&
        (err.code === 'ECONNABORTED' || err.code === 'ETIMEDOUT' || err.code === 'ECONNRESET' ||
          (err.message ?? '').toLowerCase().includes('timeout'));
      if (RETRY_METHODS.has(method) && retryable && retries < MAX_RETRIES) {
        cfg.__retries = retries + 1;
        await sleep(1500 * cfg.__retries);
        return instance.request(cfg);
      }
      return Promise.reject(error);
    }
  );

  return instance;
}

export interface LoginResponse {
  accessToken: string;
  refreshToken: string;
  user: { id: string; email: string; role: string };
}

export async function loginApi(email: string, password: string): Promise<LoginResponse> {
  const res = await axios.post<LoginResponse>(
    `${config.apiGatewayUrl}/api/v1/auth/login`,
    { email, password },
    { timeout: 25_000, validateStatus: () => true }
  );
  if (res.status !== 200) throw new Error(`Login failed (${res.status}): ${JSON.stringify(res.data)}`);
  return res.data;
}

// Cache tokens for the duration of the test run — login once per email, reuse the JWT
const _tokenCache = new Map<string, string>();

export async function loginCached(email: string, password: string): Promise<string> {
  if (_tokenCache.has(email)) return _tokenCache.get(email)!;
  const { accessToken } = await loginApi(email, password);
  _tokenCache.set(email, accessToken);
  return accessToken;
}

export function extractJson(res: AxiosResponse): unknown {
  return res.data;
}
