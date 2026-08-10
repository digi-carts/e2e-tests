@ui @smoke
Feature: Admin UI Login
  As a merchant admin
  I want to log in to the admin dashboard
  So that I can manage my store

  Background:
    Given I open the admin UI

  Scenario: Admin login page loads
    Then the page title should contain "Admin"
    And I should see an email input field
    And I should see a login button

  Scenario: Login with invalid credentials shows error
    When I enter email "bad@example.com" and password "wrongpassword"
    And I click the login button
    Then I should see an error message on the page

  @requires-creds
  Scenario: Successful admin login redirects to dashboard
    When I enter the admin credentials
    And I click the login button
    Then I should be redirected to the admin dashboard
    And I should see the store management heading
