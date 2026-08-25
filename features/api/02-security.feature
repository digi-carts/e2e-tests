@api @security @smoke
Feature: API Gateway Security
  As a security engineer
  I want the gateway to enforce authentication, rate-limit abuse, and reject spoofed headers
  So that downstream services are protected

  Scenario: Request without token is rejected on protected route
    When I GET "/api/orders"
    Then the response status should be 401
    And the response JSON should contain "error"

  Scenario: Request with invalid JWT is rejected
    Given I set the Authorization header to "Bearer invalid.token.here"
    When I GET "/api/orders"
    Then the response status should be 401

  Scenario: Request with expired JWT is rejected
    Given I have an expired JWT token for role "USER"
    When I GET "/api/orders"
    Then the response status should be 401

  Scenario: USER role cannot access ADMIN-only catalog write endpoint
    Given I have a valid JWT token for role "USER"
    When I POST "/api/catalog/products" with body:
      """
      { "name": "Hack", "price": 1 }
      """
    Then the response status should be 403

  Scenario: Spoofed x-user-role header is stripped
    Given I set header "x-user-role" to "SUPERADMIN"
    When I GET "/api/platform/manage"
    Then the response status should be 401

  Scenario: CORS preflight returns allowed headers
    When I send an OPTIONS request to "/api/auth/login" from origin "https://admin.ecom.app"
    Then the response status should be 200 or 204
    And the response header "access-control-allow-credentials" should be "true"

  Scenario: CORS from unknown origin is blocked
    When I send an OPTIONS request to "/api/auth/login" from origin "https://evil-site.com"
    Then the "access-control-allow-origin" header should not equal "https://evil-site.com"
