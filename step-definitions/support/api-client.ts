import axios, { AxiosInstance, AxiosResponse } from 'axios';
import jwt from 'jsonwebtoken';
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

/** Mint a token locally — only usable when JWT_SECRET is set in env (CI) */
export function mintToken(payload: { userId: string; email: string; role: string; storeId?: string }): string {
  if (!config.jwtSecret) throw new Error('JWT_SECRET not set — cannot mint tokens');
  return jwt.sign(payload, config.jwtSecret, { algorithm: 'HS256', expiresIn: '1h' });
}

export function extractJson(res: AxiosResponse): unknown {
  return res.data;
}
