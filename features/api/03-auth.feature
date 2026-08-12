@api @auth
Feature: Authentication API
  As a platform user
  I want to register, login, and manage my profile
  So that I can authenticate with the system

  Scenario: Public login endpoint is reachable
    When I POST "/api/auth/login" with body:
      """
      { "email": "nonexistent@test.com", "password": "wrong" }
      """
    Then the response status should be 400 or 401 or 422 or 429

  Scenario: Register endpoint validates missing fields
    When I POST "/api/auth/register" with body:
      """
      {}
      """
    Then the response status should be 400 or 422 or 429

  Scenario: Auth register endpoint is reachable
    When I POST "/api/auth/register" with body:
      """
      { "email": "not-a-valid-email", "password": "x" }
      """
    Then the response status should not be 502
    And the response status should not be 503

  Scenario: Auth refresh endpoint is reachable without token
    When I POST "/api/auth/refresh" with body:
      """
      {}
      """
    Then the response status should not be 502

  Scenario: Profile endpoint requires authentication
    When I GET "/api/auth/me"
    Then the response status should be 401

  Scenario: Change-password requires authentication only (not SUPERADMIN)
    Given I have a valid JWT token for role "USER"
    When I PATCH "/api/auth/admin-mgmt/change-password" with body:
      """
      { "oldPassword": "x", "newPassword": "y" }
      """
    Then the response status should not be 403

  Scenario: Admin management requires SUPERADMIN role
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/auth/admin-mgmt"
    Then the response status should be 403

  Scenario: SUPERADMIN can access admin management
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/auth/admin-mgmt"
    Then the response status should not be 403
    And the response status should not be 401
