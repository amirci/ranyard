Feature: Schedule API
  As a User
  I want to call /schedule (with JSON)
  So I can get the JSON response with the schedule for the conference
  
  Background:
    Given I have some conferences loaded with schedule

  Scenario: Get /schedule
    When I call API "/schedule.json"
    Then the response should be the schedule for the default conference
  
  Scenario: Get /schedule/days/1
    When I call API "/schedule/days/1.json"
    Then the response should be day "1" for the default conference
          
