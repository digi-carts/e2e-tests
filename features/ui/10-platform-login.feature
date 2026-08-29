@ui @smoke
Feature: Platform UI Login
  As a super-admin
  I want to log in to the platform dashboard
  So that I can manage the dcart platform

  Background:
    Given I open the platform UI

  Scenario: Login page loads
    Then the page title should contain "digi-carts"
    And I should see an email input field
    And I should see a password input field
    And I should see a login button

  Scenario: Login with invalid credentials shows error
    When I enter email "bad@example.com" and password "wrongpassword"
    And I click the login button
    Then I should see an error message on the page

  @requires-creds
  Scenario: Successful super-admin login redirects to dashboard
    When I enter the super-admin credentials
    And I click the login button
    Then I should be redirected to the dashboard
    And I should see the dashboard heading
