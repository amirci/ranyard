@f57
Feature: Listing sessions for a conference
  As a User
  I want to hit west.conference.com/sessions 
  So I can see only the sessions for the west conference

  Scenario: Session list for a conference
    Given I have a conference with subdomain "west"
    And   I have a conference with subdomain "east"
    When  I switch the subdomain to "west"
    And   I go to the sessions page
    Then  I should see all the active conference sessions listed    
