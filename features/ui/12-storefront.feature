@ui @smoke
Feature: Storefront
  As a customer
  I want to browse the storefront
  So that I can discover and purchase products

  Background:
    Given I open the storefront

  Scenario: Storefront homepage loads
    Then the page should load without errors
    And the page should not show a 500 error

  Scenario: Storefront hydrates past the loading skeleton
    Then I should see storefront navigation or a store status message

  Scenario: Product listing page is accessible
    When I navigate to the products page
    Then the page should load without errors
