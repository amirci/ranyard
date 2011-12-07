@f4 
Feature: Admin schedule conference
  As an Admin
  I want to plan the schedule
  So I can assigns time slots to each session

  Background: I'm and admin and the conferences are loaded
    Given I have some conferences loaded with schedule

  Scenario: Edit schedule access is available only for Admin
    Given I am not logged in
    When  I go to the schedule page
    Then  I should not be able to edit the schedule

  Scenario: Edit a schedule event
    Given I'm editing the schedule
    When  I modify an event to be at "11:00 - 12:00"
    And   I go to the schedule page
    Then  the modified event should be at "11:00 - 12:00"

  @javascript
  Scenario: Delete a schedule event
    Given I'm editing the schedule
    When  I delete an event
    And   I go to the schedule page
    Then  the deleted event should not be in the schedule

