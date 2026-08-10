@api @store
Feature: Store API
  As an admin
  I want to manage my store configuration
  So that customers see the correct store details

  Scenario: Store routes require authentication
    When I GET "/api/store"
    Then the response status should be 401

  Scenario: Store routes require ADMIN role
    Given I have a valid JWT token for role "USER"
    When I GET "/api/store"
    Then the response status should be 403

  Scenario: ADMIN can access store routes
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/store"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Public pages endpoint is accessible
    When I GET "/api/store/pages/public/home"
    Then the response status should not be 401

  Scenario: Store upload requires ADMIN role
    When I POST a multipart file to "/api/store/upload"
    Then the response status should be 401

  Scenario: Store upload rejects unsupported MIME types
    Given I have a valid JWT token for role "ADMIN"
    When I POST a multipart file with content type "application/pdf" to "/api/store/upload"
    Then the response status should be 400
    And the response JSON should contain "error" equal to "Invalid file type"

  Scenario: Domain mapping requires SUPERADMIN
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/store/domain-mapping"
    Then the response status should be 403

  Scenario: SUPERADMIN can access domain mapping
    Given I have a valid JWT token for role "SUPERADMIN"
    When I GET "/api/store/domain-mapping"
    Then the response status should not be 403
    And the response status should not be 401
