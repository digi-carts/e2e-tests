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
