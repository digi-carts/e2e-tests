@api @orders
Feature: Orders API
  As a customer or admin
  I want to place and track orders
  So that the purchase flow works end to end

  Scenario: Orders endpoint requires authentication
    When I GET "/api/orders"
    Then the response status should be 401

  Scenario: Authenticated user can access orders
    Given I have a valid JWT token for role "USER"
    When I GET "/api/orders"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Order analytics requires authentication
    When I GET "/api/orders/analytics"
    Then the response status should be 401

  Scenario: ADMIN can access order analytics
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/orders/analytics"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Stats by store requires SUPERADMIN
    When I GET "/api/orders/stats/by-store"
    Then the response status should be 401

  Scenario: ADMIN cannot access stats by store
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/orders/stats/by-store"
    Then the response status should be 403

  Scenario: Checkout requires authentication
    When I POST "/api/orders/checkout" with body:
      """
      { "items": [] }
      """
    Then the response status should be 401
