# e2e-tests — AI navigation

Cucumber + Selenium (UI) and axios (API) tests against deployed or local gateway/UIs.

**Stack:** cucumber, selenium-webdriver, axios, jsonwebtoken

## How to use this knowledge graph

1. Start here (`AGENTS.md`) for purpose, ports, and where to change X.
2. Open `docs/ai/KNOWLEDGE_GRAPH.md` for file-to-file links and task routing.
3. Prefer jumping to listed files over scanning the whole tree.
4. Browser traffic goes through **api-gateway**. Path `/api/<prefix>/...` is stripped to the service path. Downstream services trust `x-user-id`, `x-user-email`, `x-user-role`, `x-store-id` injected by the gateway — they do not re-validate JWTs.
5. Roles: `user` (shopper), `merchant` (store admin), `superadmin` (platform).


## Jump table

| Task | File |
| --- | --- |
| URLs, credentials, JWT | `step-definitions/support/config.ts` |
| World / hooks | `step-definitions/support/world.ts` |
| Selenium driver | `step-definitions/support/driver.ts` |
| API helper | `step-definitions/support/api-client.ts` |
| API steps | `step-definitions/api/api-steps.ts` |
| UI steps | `step-definitions/ui/ui-steps.ts` |
| CI | `.github/workflows/e2e.yml` |
| Cucumber config | `cucumber.json` |

Env: `API_GATEWAY_URL`, `PLATFORM_UI_URL`, `ADMIN_UI_URL`, `STOREFRONT_URL`, `JWT_SECRET` / `E2E_*` credentials.
