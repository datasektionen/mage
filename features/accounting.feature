Feature: Accounting
  In order to get a decent overview
  As an admin
  I want to be able to see recent vouchers etc.

  Background:
    Given I am logged in

  Scenario: Two activity years
    Given an activity year 2011 with vouchers
    And an activity year 2012 with vouchers
    And the current activity year is 2012
    When I go to the accounting page
    Then I should see vouchers for 2012
    And I should not see vouchers for 2011

