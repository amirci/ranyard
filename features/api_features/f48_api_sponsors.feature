@f48
Feature: API list sponsors
  As a Developer
  I want to query sponsors in the API
  So I can list them in my application


  Scenario: Listing sponsors
    Given I have some conferences loaded
    When  I query the API for sponsors
    Then  I should get all the sponsors listed as JSON