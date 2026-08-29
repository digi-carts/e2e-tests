@ui @requires-creds
Feature: Platform UI pages load
  As a super-admin
  I want every Super Admin Portal page to open after login
  So that navigation matches the live app

  Background:
    Given I open the platform UI
    When I enter the super-admin credentials
    And I click the login button
    Then I should be redirected to the dashboard

  Scenario Outline: Super-admin page shows its heading
    When I open the platform path "<path>"
    Then I should see the heading "<heading>"

    Examples:
      | path                       | heading                |
      | /dashboard                 | Dashboard              |
      | /admins                    | Admins                 |
      | /superadmins               | Super Admins           |
      | /stores                    | Stores                 |
      | /customers                 | Customers              |
      | /templates                 | Store Templates        |
      | /setup-wizard              | Setup Wizard           |
      | /services                  | Services               |
      | /notifications             | Notifications          |
      | /payment                   | Payment Settings       |
      | /firebase                  | Firebase Auth Config   |
      | /support                   | Support Tickets        |
      | /cleanup                   | SQL Console            |
      | /settings                  | Settings               |
      | /settings/info-content     | Info Modal Content     |
      | /subscriptions             | Subscription Plans     |
      | /subscriptions/features    | Feature Limits         |
      | /subscriptions/discounts   | Discounts              |
