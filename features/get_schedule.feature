Feature: Schedule
  As a User
  I want to see the schedule
  So I can choose sessions to go

  Scenario: Show the schedule
    Given  I have some conferences loaded with schedule
    When   I go to the schedule page
    Then   I should see the schedule of the conference
            
            
