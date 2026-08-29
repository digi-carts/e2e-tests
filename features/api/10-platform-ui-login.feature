@api @auth @platform
Feature: Platform UI login APIs
  As a super-admin
  I want the APIs used by platform-ui login and the post-login dashboard
  So that the Super Admin Portal can sign in and load

  # platform-ui login page: POST /auth/login
  # axios interceptor: POST /auth/refresh on 401
  # dashboard after redirect: GET /platform/analytics

  Scenario: Login with empty body is rejected
    When I POST "/api/v1/auth/login" with body:
      """
      {}
      """
    Then the response status should be 400 or 422

  Scenario: Login with invalid credentials is rejected
    When I POST "/api/v1/auth/login" with body:
      """
      { "email": "bad@example.com", "password": "wrongpassword" }
      """
    Then the response status should be 401

  @smoke
  Scenario: Super-admin login returns tokens and superadmin role
    When I log in as "SUPERADMIN" via the login API
    Then the response status should be 200
    And the JSON field "accessToken" should be a non-empty string
    And the JSON field "refreshToken" should be a non-empty string
    And the nested JSON "user.role" should be "superadmin"

  Scenario: Merchant login is not a superadmin account
    When I log in as "MERCHANT" via the login API
    Then the response status should be 200
    And the nested JSON "user.role" should be "merchant"

  Scenario: Refresh with empty body is rejected
    When I POST "/api/v1/auth/refresh" with body:
      """
      {}
      """
    Then the response status should be 400 or 401 or 422

  Scenario: Refresh with an invalid token is rejected
    When I POST refresh using an invalid refresh token
    Then the response status should be 400 or 401 or 422

  Scenario: Super-admin refresh token issues a new access token
    When I log in as "SUPERADMIN" via the login API
    And I POST refresh using the last refresh token
    Then the response status should be 200
    And the JSON field "accessToken" should be a non-empty string
    And the JSON field "refreshToken" should be a non-empty string

  Scenario: Dashboard analytics requires authentication
    When I GET "/api/v1/platform/analytics"
    Then the response status should be 401

  Scenario: Merchant cannot load super-admin dashboard analytics
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/v1/platform/analytics"
    Then the response status should be 403

  @smoke
  Scenario: Super-admin can load dashboard analytics after login
    When I log in as "SUPERADMIN" via the login API
    And I GET "/api/v1/platform/analytics"
    Then the response status should be 200
    And the response JSON should contain "stores"
    And the response JSON should contain "orders"
    And the response JSON should contain "customers"
    And the response JSON should contain "subscriptions"
    And the response JSON should contain "supportTickets"
    And the nested JSON "customers.total" should be a number
    And the nested JSON "customers.active" should be a number
    And the nested JSON "customers.inactive" should be a number
    And the nested JSON "stores.total" should be a number
    And the nested JSON "stores.published" should be a number
    And the nested JSON "stores.expired" should be a number
    And the nested JSON "orders.total" should be a number
    And the nested JSON "subscriptions.total" should be a number
    And the nested JSON "supportTickets.total" should be a number
    And the nested JSON "supportTickets.pending" should be a number
    And the nested JSON "admins.total" should be a number
