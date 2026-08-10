@api @smoke
Feature: API Gateway Health
  As an ops engineer
  I want to verify the api-gateway is running and healthy
  So that I know the service is up before running full test suites

  Scenario: Health endpoint returns ok
    When I GET "/health"
    Then the response status should be 200
    And the response JSON should contain "status" equal to "ok"
    And the response JSON should contain "service" equal to "api-gateway"

  Scenario: Unknown route returns 404
    When I GET "/api/does-not-exist-xyz"
    Then the response status should be 404

  Scenario: X-Powered-By header is not present
    When I GET "/health"
    Then the response header "x-powered-by" should not be present

  Scenario: Security headers are set
    When I GET "/health"
    Then the response header "x-content-type-options" should be "nosniff"
