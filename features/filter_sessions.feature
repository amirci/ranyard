Feature: filter sessions
  As a potential Customer
  I want to filter the list of Sessions
  So I can list the sessions that I find interesting

  Background: I have a list of sessions
    Given I have some conferences loaded
    When  I go to the sessions page
    
  Scenario: See tags on the Sessions view
    Then I should see the list of tags for all the sessions

  @javascript
  Scenario: Filter sessions by tags
    When I apply the session filter
    Then I should see only the sessions with the filtered tag

  @javascript
  Scenario: Can clear session filters
    Given I apply the session filter
    When  I clear the filter 
    Then  I should see all the active conference sessions listed    
