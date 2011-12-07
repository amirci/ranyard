Feature: get sessions
  As a potential Customer
  I want to see the list of Sessions
  So I can decide if I want to attend the conference

  Background: I have a list of sessions
    Given I have some conferences loaded with schedule
    When  I go to the sessions page

  Scenario: View the list of Sessions
    Then  I should see all the active conference sessions listed    

  Scenario: Session admin options are not available
    Then I should not be able to create a new session
    And  I should not be able to edit any sessions
    And  I should not be able to delete any sessions
