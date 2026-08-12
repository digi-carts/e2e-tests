import { Given, When, Then } from '@cucumber/cucumber';
import axios from 'axios';
import assert from 'node:assert/strict';
import { EcomWorld } from '../support/world';
import { createApiClient, mintToken } from '../support/api-client';
import { config } from '../support/config';
import FormData from 'form-data';

// ─── Auth setup steps ─────────────────────────────────────────────────────────

Given('I set the Authorization header to {string}', function (this: EcomWorld, header: string) {
  this.api = createApiClient(header.replace('Bearer ', ''));
});

Given('I have a valid JWT token for role {string}', function (this: EcomWorld, role: string) {
  const token = mintToken({
    userId: `e2e-${role.toLowerCase()}-user`,
    email: `e2e-${role.toLowerCase()}@test.com`,
    role,
    storeId: role === 'ADMIN' ? 'e2e-store-001' : undefined,
  });
  this.token = token;
  this.api = createApiClient(token);
});

Given('I have an expired JWT token for role {string}', function (this: EcomWorld, role: string) {
  if (!config.jwtSecret) throw new Error('JWT_SECRET not set');
  const jwt = require('jsonwebtoken');
  const token = jwt.sign(
    { userId: 'expired-user', email: 'expired@test.com', role },
    config.jwtSecret,
    { algorithm: 'HS256', expiresIn: '-1s' }
  );
  this.api = createApiClient(token);
});

Given('I set header {string} to {string}', function (this: EcomWorld, headerName: string, headerValue: string) {
  this.api = axios.create({
    baseURL: config.apiGatewayUrl,
    timeout: 15_000,
    headers: { [headerName]: headerValue },
    validateStatus: () => true,
  });
});

// ─── Request steps ────────────────────────────────────────────────────────────

When('I GET {string}', async function (this: EcomWorld, path: string) {
  this.lastResponse = await this.api.get(path);
});

When('I POST {string} with body:', async function (this: EcomWorld, path: string, body: string) {
  this.lastResponse = await this.api.post(path, JSON.parse(body), {
    headers: { 'Content-Type': 'application/json' },
  });
});

When('I PATCH {string} with body:', async function (this: EcomWorld, path: string, body: string) {
  this.lastResponse = await this.api.patch(path, JSON.parse(body), {
    headers: { 'Content-Type': 'application/json' },
  });
});

When('I DELETE {string}', async function (this: EcomWorld, path: string) {
  this.lastResponse = await this.api.delete(path);
});

When('I send an OPTIONS request to {string} from origin {string}', async function (this: EcomWorld, path: string, origin: string) {
  this.lastResponse = await axios.options(`${config.apiGatewayUrl}${path}`, {
    headers: {
      Origin: origin,
      'Access-Control-Request-Method': 'POST',
      'Access-Control-Request-Headers': 'content-type,authorization',
    },
    validateStatus: () => true,
  });
});

When('I POST a multipart file to {string}', async function (this: EcomWorld, path: string) {
  const form = new FormData();
  form.append('file', Buffer.from('fake-image'), { filename: 'test.jpg', contentType: 'image/jpeg' });
  this.lastResponse = await this.api.post(path, form, {
    headers: form.getHeaders(),
  });
});

When('I POST a multipart file with content type {string} to {string}', async function (this: EcomWorld, mimeType: string, path: string) {
  const form = new FormData();
  const fieldName = path.includes('/catalog/') ? 'image' : 'file';
  form.append(fieldName, Buffer.from('fake-content'), { filename: 'test.txt', contentType: mimeType });
  this.lastResponse = await this.api.post(path, form, {
    headers: form.getHeaders(),
  });
});

// ─── Assertion steps ──────────────────────────────────────────────────────────

Then('the response status should be {int}', function (this: EcomWorld, expectedStatus: number) {
  assert.ok(this.lastResponse, 'No response recorded');
  assert.equal(
    this.lastResponse.status,
    expectedStatus,
    `Expected status ${expectedStatus} but got ${this.lastResponse.status}. Body: ${JSON.stringify(this.lastResponse.data)}`
  );
});

Then('the response status should be {int} or {int}', function (this: EcomWorld, s1: number, s2: number) {
  assert.ok(this.lastResponse, 'No response recorded');
  assert.ok(
    [s1, s2].includes(this.lastResponse.status),
    `Expected ${s1} or ${s2} but got ${this.lastResponse.status}`
  );
});

Then('the response status should be {int} or {int} or {int}', function (this: EcomWorld, s1: number, s2: number, s3: number) {
  assert.ok(this.lastResponse, 'No response recorded');
  assert.ok(
    [s1, s2, s3].includes(this.lastResponse.status),
    `Expected ${s1}, ${s2}, or ${s3} but got ${this.lastResponse.status}`
  );
});

Then('the response status should be {int} or {int} or {int} or {int}', function (this: EcomWorld, s1: number, s2: number, s3: number, s4: number) {
  assert.ok(this.lastResponse, 'No response recorded');
  assert.ok(
    [s1, s2, s3, s4].includes(this.lastResponse.status),
    `Expected ${s1}, ${s2}, ${s3}, or ${s4} but got ${this.lastResponse.status}`
  );
});

Then('the response status should not be {int}', function (this: EcomWorld, unexpectedStatus: number) {
  assert.ok(this.lastResponse, 'No response recorded');
  assert.notEqual(
    this.lastResponse.status,
    unexpectedStatus,
    `Expected status to not be ${unexpectedStatus}. Body: ${JSON.stringify(this.lastResponse.data)}`
  );
});

Then('the response JSON should contain {string}', function (this: EcomWorld, key: string) {
  assert.ok(this.lastResponse, 'No response recorded');
  assert.ok(
    typeof this.lastResponse.data === 'object' && this.lastResponse.data !== null && key in this.lastResponse.data,
    `Key "${key}" not found in response: ${JSON.stringify(this.lastResponse.data)}`
  );
});

Then('the response JSON should contain {string} equal to {string}', function (this: EcomWorld, key: string, value: string) {
  assert.ok(this.lastResponse, 'No response recorded');
  const data = this.lastResponse.data as Record<string, unknown>;
  assert.equal(data[key], value, `Expected ${key}="${value}" but got ${JSON.stringify(data[key])}`);
});

Then('the response header {string} should not be present', function (this: EcomWorld, headerName: string) {
  assert.ok(this.lastResponse, 'No response recorded');
  const val = this.lastResponse.headers[headerName.toLowerCase()];
  assert.ok(!val, `Expected header "${headerName}" to be absent but found: ${val}`);
});

Then('the response header {string} should be {string}', function (this: EcomWorld, headerName: string, expectedValue: string) {
  assert.ok(this.lastResponse, 'No response recorded');
  const actual = this.lastResponse.headers[headerName.toLowerCase()];
  assert.ok(actual, `Header "${headerName}" was not present`);
  assert.ok(
    String(actual).toLowerCase().includes(expectedValue.toLowerCase()),
    `Expected header "${headerName}" to contain "${expectedValue}" but got "${actual}"`
  );
});

Then('the {string} header should not equal {string}', function (this: EcomWorld, headerName: string, value: string) {
  assert.ok(this.lastResponse, 'No response recorded');
  const actual = this.lastResponse.headers[headerName.toLowerCase()];
  assert.notEqual(actual, value, `Expected header "${headerName}" to NOT equal "${value}"`);
});

Then('the response body should be a JSON array or object', function (this: EcomWorld) {
  assert.ok(this.lastResponse, 'No response recorded');
  assert.ok(
    typeof this.lastResponse.data === 'object' || Array.isArray(this.lastResponse.data),
    `Expected JSON array or object but got: ${typeof this.lastResponse.data}`
  );
});
