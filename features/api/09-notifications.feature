@api @notifications
Feature: Notifications API
  As an admin
  I want to configure notifications and view logs
  So that customers receive order updates

  Scenario: Notification config requires ADMIN or SUPERADMIN
    When I GET "/api/v1/notifications/config"
    Then the response status should be 401

  Scenario: USER cannot access notification config
    Given I have a valid JWT token for role "USER"
    When I GET "/api/v1/notifications/config"
    Then the response status should be 403

  Scenario: ADMIN can access notification config
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/v1/notifications/config"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Notification logs require ADMIN
    When I GET "/api/v1/notifications/logs"
    Then the response status should be 401

  Scenario: Notify endpoint requires authentication
    When I POST "/api/v1/notifications/notify/order-confirmation" with body:
      """
      { "orderId": "test-123" }
      """
    Then the response status should be 401
