@api @shipping
Feature: Shipping API
  As a customer or admin
  I want to calculate shipping rates and configure shipping settings
  So that the checkout shows correct delivery costs

  Scenario: Shipping rates endpoint is publicly accessible
    When I POST "/api/v1/shipping/rates" with body:
      """
      { "weight": 1, "destination": "IN" }
      """
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Shipping config requires ADMIN
    When I GET "/api/v1/shipping/config"
    Then the response status should be 401

  Scenario: USER cannot access shipping config
    Given I have a valid JWT token for role "USER"
    When I GET "/api/v1/shipping/config"
    Then the response status should be 403

  Scenario: ADMIN can access shipping config
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/v1/shipping/config"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Shipping fallbacks requires ADMIN
    When I GET "/api/v1/shipping/fallbacks"
    Then the response status should be 401
