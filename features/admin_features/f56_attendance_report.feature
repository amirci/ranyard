@f56
Feature: Attendance Report
  As an admin 
  I want a report showing intended attendance to sessions ranked by votes
  So I can see which sessions are more popular
  
  Background: I'm and admin and the conferences are loaded
    Given I have some conferences loaded
    And   I'm logged in as an admin
    And   I go to the sessions page

  Scenario: Getting the attendance report
    When I open the attendance report
    Then I should see the attendance information for the sessions
    