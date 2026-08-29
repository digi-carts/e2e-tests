@ui @smoke @requires-creds
Feature: Platform UI Dashboard
  As a super-admin
  I want the dashboard to load with live analytics
  So that I can see customers, stores, orders, plans, and tickets

  Background:
    Given I open the platform UI
    When I enter the super-admin credentials
    And I click the login button
    Then I should be redirected to the dashboard

  Scenario: Dashboard heading and super-admin chrome are visible
    Then I should see the heading "Dashboard"
    And I should see the text "Super Admin"
    And I should see the text "Total Customers"

  Scenario: Dashboard stat cards show numeric analytics data
    Then I should see these dashboard stats with numeric values:
      | Total Customers     |
      | Active Customers    |
      | Inactive Customers  |
      | Stores              |
      | Total Orders        |
      | Subscription Plans  |
      | Support Tickets     |
