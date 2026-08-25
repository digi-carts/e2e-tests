import axios, { AxiosInstance, AxiosResponse } from 'axios';
import { config } from './config';

export function createApiClient(token?: string): AxiosInstance {
  return axios.create({
    baseURL: config.apiGatewayUrl,
    timeout: 15_000,
    headers: token ? { Authorization: `Bearer ${token}` } : {},
    validateStatus: () => true, // never throw on HTTP errors — let tests assert
  });
}

export interface LoginResponse {
  token: string;
  user: { id: string; email: string; role: string };
}

export async function loginApi(email: string, password: string): Promise<LoginResponse> {
  const res = await axios.post<LoginResponse>(
    `${config.apiGatewayUrl}/api/auth/login`,
    { email, password },
    { timeout: 15_000, validateStatus: () => true }
  );
  if (res.status !== 200) throw new Error(`Login failed (${res.status}): ${JSON.stringify(res.data)}`);
  return res.data;
}

// Cache tokens for the duration of the test run — login once per email, reuse the JWT
const _tokenCache = new Map<string, string>();

export async function loginCached(email: string, password: string): Promise<string> {
  if (_tokenCache.has(email)) return _tokenCache.get(email)!;
  const { token } = await loginApi(email, password);
  _tokenCache.set(email, token);
  return token;
}

export function extractJson(res: AxiosResponse): unknown {
  return res.data;
}
