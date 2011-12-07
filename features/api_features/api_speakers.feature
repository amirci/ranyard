Feature: Speakers API
  As a User
  I want to call /speakers (with JSON)
  So I can get the JSON response with all the speakers

  Background:
    Given I have some conferences loaded

  Scenario: Listing speakers
    When I call API "/speakers.json"
    Then the response should be all the speakers for the default conference

  Scenario: Listing one speaker
    When I call API "/speakers/1.json"
    Then the response should be the speaker with id "1"
