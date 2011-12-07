Feature: Sessions API
  As a User
  I want to call /sessions (with JSON)
  So I can get the JSON response with all the sessions

  Background:
    Given I have some conferences loaded with schedule

  Scenario: Listing sessions
    When I call API "/sessions.json"
    Then the response should be all the sessions for the default conference

  Scenario: Listing one session  
    When I call API "/sessions/1.json"
    Then the response should be the session with id "1"
