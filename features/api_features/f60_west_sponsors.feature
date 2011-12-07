@f60
Feature: API list sponsors for subdomain west
  As a User
  I want to hit west.prdc.com/sponsors
  So I can get the JSON of the sponsors for the west subdomain

  
  Scenario: Listing sponsors as JSON
    Given I have a conference with subdomain "west"
    And   I have a conference with subdomain "east"
    And   I switch the subdomain to "west"
    When  I query the API for sponsors
    Then  I should get all the sponsors listed as JSON for the active conference