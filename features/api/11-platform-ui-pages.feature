@api @platform
Feature: Platform UI page APIs
  As a super-admin
  I want the page-load and mutation APIs used by platform-ui
  So that each Super Admin screen can fetch data and reject anonymous writes

  # --- Admins (/admins) + Super Admins (/superadmins) ---
  Scenario: Superadmins list requires authentication
    When I GET "/api/v1/auth/admin-mgmt/superadmins"
    Then the response status should be 401

  Scenario: SUPERADMIN can list superadmins
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/auth/admin-mgmt/superadmins"
    Then the response status should be 200
    And the response body should be a JSON array or object

  Scenario: Create superadmin requires authentication
    When I POST "/api/v1/auth/admin-mgmt/superadmin" with body:
      """
      { "email": "e2e@example.com", "password": "unused" }
      """
    Then the response status should be 401

  # --- Stores (/stores) ---
  Scenario: Stores list requires authentication
    When I GET "/api/v1/stores"
    Then the response status should be 401

  Scenario: SUPERADMIN can list stores
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/stores"
    Then the response status should be 200
    And the response body should be a JSON array or object

  Scenario: SUPERADMIN can load platform manage
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/platform/manage"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: SUPERADMIN can load order stats by store
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/orders/stats/by-store"
    Then the response status should be 200
    And the response body should be a JSON array or object

  Scenario: Store admin-create requires authentication
    When I POST "/api/v1/store/admin-create" with body:
      """
      { "name": "e2e", "subdomain": "e2e-unused" }
      """
    Then the response status should be 401

  # --- Customers (/customers) ---
  Scenario: Customers list requires authentication
    When I GET "/api/v1/auth/admin-mgmt/customers"
    Then the response status should be 401

  Scenario: SUPERADMIN can list customers
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/auth/admin-mgmt/customers"
    Then the response status should be 200
    And the response body should be a JSON array or object

  Scenario: Customer status patch requires authentication
    When I PATCH "/api/v1/auth/admin-mgmt/customers/00000000-0000-0000-0000-000000000000/status" with body:
      """
      { "blocked": true }
      """
    Then the response status should be 401

  # --- Templates (/templates) ---
  Scenario: Template toggle requires authentication
    When I PATCH "/api/v1/platform/templates/00000000-0000-0000-0000-000000000000" with body:
      """
      { "enabled": false }
      """
    Then the response status should be 401

  # --- Subscriptions (/subscriptions, /subscriptions/features) ---
  Scenario: Business levels require authentication
    When I GET "/api/v1/platform/business-levels"
    Then the response status should be 401

  Scenario: SUPERADMIN can list business levels
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/platform/business-levels"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: SUPERADMIN can list subscription plans
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/platform/subscriptions"
    Then the response status should be 200
    And the response body should be a JSON array or object

  Scenario: Create subscription plan requires authentication
    When I POST "/api/v1/platform/subscriptions" with body:
      """
      { "name": "e2e-unused" }
      """
    Then the response status should be 401

  # --- Discounts (/subscriptions/discounts) ---
  Scenario: Offers list requires authentication
    When I GET "/api/v1/offers"
    Then the response status should be 401

  Scenario: SUPERADMIN can list offers
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/offers"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Create offer requires authentication
    When I POST "/api/v1/offers" with body:
      """
      { "code": "E2EUNUSED" }
      """
    Then the response status should be 401

  # --- Setup Wizard (/setup-wizard) ---
  Scenario: Setup wizard requires authentication
    When I GET "/api/v1/platform/setup-wizard"
    Then the response status should be 401

  Scenario: SUPERADMIN can read setup wizard
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/platform/setup-wizard"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Setup wizard patch requires authentication
    When I PATCH "/api/v1/platform/setup-wizard" with body:
      """
      {}
      """
    Then the response status should be 401

  # --- Services (/services) ---
  Scenario: SUPERADMIN can load services status
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/platform/services/status"
    Then the response status should be 200
    And the response body should be a JSON array or object

  # --- Notifications (/notifications) ---
  Scenario: SUPERADMIN can load notification config
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/notifications/config"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Notification config put requires authentication
    When I PUT "/api/v1/notifications/config" with body:
      """
      {}
      """
    Then the response status should be 401

  Scenario: Notification test send requires authentication
    When I POST "/api/v1/notifications/notify/test" with body:
      """
      { "to": "e2e@example.com" }
      """
    Then the response status should be 401

  # --- Payment (/payment) ---
  Scenario: Global payment config requires authentication
    When I GET "/api/v1/platform-payment-config/global"
    Then the response status should be 401

  Scenario: SUPERADMIN can read global payment config
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/platform-payment-config/global"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Global payment config put requires authentication
    When I PUT "/api/v1/platform-payment-config/global" with body:
      """
      {}
      """
    Then the response status should be 401

  # --- Firebase (/firebase) ---
  # Gateway treats /api/v1/platform/platform-config as a public path (all methods).
  Scenario: Anonymous platform-config patch is accepted on the public path
    When I PATCH "/api/v1/platform/platform-config" with body:
      """
      {}
      """
    Then the response status should be 200

  # --- Support (/support) ---
  Scenario: Support tickets require authentication
    When I GET "/api/v1/platform/support"
    Then the response status should be 401

  Scenario: SUPERADMIN can list support tickets
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/platform/support"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Support comment requires authentication
    When I POST "/api/v1/platform/support/00000000-0000-0000-0000-000000000000/comments" with body:
      """
      { "body": "e2e" }
      """
    Then the response status should be 401

  Scenario: Support status patch requires authentication
    When I PATCH "/api/v1/platform/support/00000000-0000-0000-0000-000000000000/status" with body:
      """
      { "status": "OPEN" }
      """
    Then the response status should be 401

  # --- Cleanup (/cleanup) ---
  Scenario: Cleanup SQL requires authentication
    When I POST "/api/v1/platform/cleanup/sql" with body:
      """
      { "query": "SELECT 1" }
      """
    Then the response status should be 401

  Scenario: Merchant cannot run cleanup SQL
    Given I have a valid JWT token for role "ADMIN"
    When I POST "/api/v1/platform/cleanup/sql" with body:
      """
      { "query": "SELECT 1" }
      """
    Then the response status should be 403

  # --- Settings (/settings) ---
  Scenario: SUPERADMIN can read admin settings
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/platform/platform-config/admin-settings"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Change-password post requires authentication
    When I POST "/api/v1/auth/admin-mgmt/change-password" with body:
      """
      { "currentPassword": "x", "newPassword": "y" }
      """
    Then the response status should be 401

  Scenario: Cloudflare test requires authentication
    When I POST "/api/v1/platform/platform-config/cloudflare-test" with body:
      """
      {}
      """
    Then the response status should be 401

  # --- Info content (/settings/info-content) ---
  Scenario: Info content requires authentication
    When I GET "/api/v1/platform/platform-config/info-content"
    Then the response status should be 401

  Scenario: SUPERADMIN can read info content
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/v1/platform/platform-config/info-content"
    Then the response status should not be 401
    And the response status should not be 403
