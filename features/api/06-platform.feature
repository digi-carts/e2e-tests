@api @platform
Feature: Platform API
  As a super-admin
  I want to manage subscriptions, templates, and platform configuration
  So that the platform operates correctly

  Scenario: Platform config is publicly readable
    When I GET "/api/platform/platform-config"
    Then the response status should be 200

  Scenario: Templates list is publicly readable
    When I GET "/api/platform/templates"
    Then the response status should be 200

  Scenario: Admin settings require SUPERADMIN
    When I GET "/api/platform/platform-config/admin-settings"
    Then the response status should be 401

  Scenario: ADMIN cannot access admin-settings
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/platform/platform-config/admin-settings"
    Then the response status should be 403

  Scenario: Services status requires SUPERADMIN
    When I GET "/api/platform/services/status"
    Then the response status should be 401

  Scenario: Subscription status requires ADMIN
    When I GET "/api/platform/subscription-status"
    Then the response status should be 401

  Scenario: ADMIN can view subscription status
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/platform/subscription-status"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Subscriptions list accessible by ADMIN
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/platform/subscriptions"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Platform manage requires SUPERADMIN
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/platform/manage"
    Then the response status should be 403

  Scenario: Cleanup schema requires SUPERADMIN
    When I GET "/api/platform/cleanup/schema"
    Then the response status should be 401

  Scenario: ADMIN cannot access cleanup schema
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/platform/cleanup/schema"
    Then the response status should be 403

  Scenario: SUPERADMIN can access cleanup schema
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/platform/cleanup/schema"
    Then the response status should be 200
    And the response JSON should contain "schema"
    And the response JSON should contain "tables"

  Scenario: GET AI config requires authentication
    When I GET "/api/platform/platform-config/ai"
    Then the response status should be 401

  Scenario: SUPERADMIN can read AI config
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/platform/platform-config/ai"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: PATCH info-content requires authentication
    When I PATCH "/api/platform/platform-config/info-content" with body:
      """
      {}
      """
    Then the response status should be 401

  Scenario: SUPERADMIN can patch info-content
    Given I have a valid JWT token for role "SUPERADMIN"
    When I PATCH "/api/platform/platform-config/info-content" with body:
      """
      {}
      """
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: AI chat requires authentication
    When I POST "/api/platform/platform-config/ai-chat" with body:
      """
      { "message": "hello" }
      """
    Then the response status should be 401

  Scenario: Admin upsert-status requires SUPERADMIN
    Given I have a valid JWT token for role "ADMIN"
    When I POST "/api/platform/admin/upsert-status" with body:
      """
      { "email": "test@example.com", "status": "active" }
      """
    Then the response status should be 403

  Scenario: PATCH admin status requires SUPERADMIN
    Given I have a valid JWT token for role "ADMIN"
    When I PATCH "/api/platform/admin/00000000-0000-0000-0000-000000000000/status" with body:
      """
      { "status": "active" }
      """
    Then the response status should be 403

  Scenario: PATCH admin subscription requires SUPERADMIN
    Given I have a valid JWT token for role "ADMIN"
    When I PATCH "/api/platform/admin/00000000-0000-0000-0000-000000000000/subscription" with body:
      """
      { "plan": "pro" }
      """
    Then the response status should be 403
