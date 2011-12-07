@f63
Feature: Get the schedule for the west conference
  As a User
  I want to hit xxx.site.com/Schedule
  So I can see the schedule for xxx subdomain


  Scenario: Show the schedule for west
    Given I have a conference with subdomain "west"
    And   I have a conference with subdomain "east"
    When  I switch the subdomain to "west"
    And   I go to the schedule page
    Then  I should see the schedule of the active conference
  