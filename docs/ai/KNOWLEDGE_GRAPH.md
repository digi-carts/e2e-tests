# Knowledge graph — e2e-tests

```mermaid
flowchart LR
  subgraph UIs
    PUI[platform-ui]
    MUI[merchant-ui]
    SF[storefront]
  end
  GW[api-gateway :4000]
  PUI --> GW
  MUI --> GW
  SF --> GW
  GW --> AUTH[auth-service :3001]
  GW --> PLAT[platform-service :3002]
  GW --> STORE[store-service :3003]
  GW --> CAT[catalog-service :3004]
  GW --> ORD[order-service :3005]
  GW --> SFS[storefront-service :3006]
  GW --> NOTIF[notification-service :3007]
  GW --> PAY[payment-service :3008]
  GW --> SHIP[shipping-service :3009]
  GW --> OFF[offer-service :3010]
  GW --> BILL[billing-service :3011]
```


## This repo

```mermaid
flowchart TD
  CUC[cucumber.json]
  CUC --> API[step-definitions/api/api-steps.ts]
  CUC --> UI[step-definitions/ui/ui-steps.ts]
  API --> CLIENT[step-definitions/support/api-client.ts]
  UI --> DRV[step-definitions/support/driver.ts]
  CLIENT --> CFG[step-definitions/support/config.ts]
  DRV --> CFG
  CFG --> GW[api-gateway]
  CFG --> UIs[platform-ui merchant-ui storefront]
```

## Task → file

- New API assertion: `step-definitions/api/api-steps.ts` + `api-client.ts`.
- New UI flow: `step-definitions/ui/ui-steps.ts` plus feature files if present.
- Wrong environment: `step-definitions/support/config.ts`.
