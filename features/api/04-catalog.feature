@api @catalog
Feature: Catalog API
  As a customer or admin
  I want to browse products and categories
  So that I can view and manage the product catalogue

  Scenario: Public products list is accessible without auth
    When I GET "/api/catalog/products"
    Then the response status should be 200
    And the response body should be a JSON array or object

  Scenario: Public categories list is accessible without auth
    When I GET "/api/catalog/categories"
    Then the response status should be 200

  Scenario: Stock summary requires ADMIN role
    When I GET "/api/catalog/products/stock-summary"
    Then the response status should be 401

  Scenario: ADMIN can access stock summary
    Given I have a valid JWT token for role "ADMIN"
    When I GET "/api/catalog/products/stock-summary"
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Creating a product requires ADMIN auth
    When I POST "/api/catalog/products" with body:
      """
      { "name": "Test Product", "price": 99.99, "storeId": "store-1" }
      """
    Then the response status should be 401

  Scenario: ADMIN can create a product
    Given I have a valid JWT token for role "ADMIN"
    When I POST "/api/catalog/products" with body:
      """
      { "name": "E2E Test Product", "price": 10, "storeId": "test-store" }
      """
    Then the response status should not be 401
    And the response status should not be 403

  Scenario: Upload image without auth returns 401
    When I POST a multipart file to "/api/catalog/products/abc123/images"
    Then the response status should be 401

  Scenario: Upload image with wrong MIME type returns 400
    Given I have a valid JWT token for role "ADMIN"
    When I POST a multipart file with content type "text/plain" to "/api/catalog/products/abc123/images"
    Then the response status should be 400
    And the response JSON should contain "error" equal to "Invalid file type"
