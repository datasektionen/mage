Feature: Vouchers
  In order to do proper bookkeeping
  As an admin
  I want to be able to create vouchers

  Background:
    Given I am logged in
    And I go to the vouchers page

  Scenario: Creating a voucher
    Given I follow "Nytt verifikat"
    And I fill out the event form with some data
    When I press "voucher_submit"
    Then a voucher should have been created

