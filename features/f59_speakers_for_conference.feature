@f59
Feature: Listing presenters for a conference
  As a User
  I want to go to west.domain.com/speakers
  So I can see the speakers page for west conference

  Scenario: Speaker info and session details
    Given I have a conference with subdomain "west"
    And   I have a conference with subdomain "east"
    When  I switch the subdomain to "west"
    And   I go to the speakers page
    Then  I should see all the active conference speakers listed    
