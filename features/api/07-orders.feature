@api @orders
Feature: Orders API
  As a customer or admin
  I want to place and track orders
  So that the purchase flow works end to end

  Scenario: Orders endpoint requires authentication
    When I GET "/api/v1/orders"
    Then the response status should be 401

  Scenario: Authenticated user can access orders
    Given I have a valid JWT token for role "USER"
    When I GET "/api/v1/orders"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Order analytics requires authentication
    When I GET "/api/v1/orders/analytics"
    Then the response status should be 401

  Scenario: ADMIN can access order analytics
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/v1/orders/analytics"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Stats by store requires SUPERADMIN
    When I GET "/api/v1/orders/stats/by-store"
    Then the response status should be 401

  Scenario: ADMIN cannot access stats by store
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/v1/orders/stats/by-store"
    Then the response status should be 403

  Scenario: Checkout requires authentication
    When I POST "/api/v1/orders/checkout" with body:
      """
      { "items": [] }
      """
    Then the response status should be 401

  Scenario: PATCH order status requires authentication
    When I PATCH "/api/v1/orders/00000000-0000-0000-0000-000000000000/status" with body:
      """
      { "status": "CONFIRMED" }
      """
    Then the response status should be 401

  Scenario: ADMIN can patch order status (404 for non-existent order)
    Given I have a valid JWT token for role "ADMIN"
    When I PATCH "/api/v1/orders/00000000-0000-0000-0000-000000000000/status" with body:
      """
      { "status": "CONFIRMED" }
      """
    Then the response status should be 404

  Scenario: Returns endpoint requires authentication
    When I GET "/api/v1/returns"
    Then the response status should be 401 or 404

  Scenario: PATCH return status requires authentication
    When I PATCH "/api/v1/returns/00000000-0000-0000-0000-000000000000/status" with body:
      """
      { "status": "APPROVED" }
      """
    Then the response status should be 401 or 404

  Scenario: ADMIN can patch return status (404 for non-existent return)
    Given I have a valid JWT token for role "ADMIN"
    When I PATCH "/api/v1/returns/00000000-0000-0000-0000-000000000000/status" with body:
      """
      { "status": "APPROVED" }
      """
    Then the response status should be 404

  Scenario: POST order return requires authentication
    When I POST "/api/v1/orders/00000000-0000-0000-0000-000000000000/return" with body:
      """
      { "reason": "damaged" }
      """
    Then the response status should be 401
