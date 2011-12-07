Feature: Listing presenters
  As a User
  I want to see the list of presenters
  So I can read someone's bio

  Background:
    Given I have some conferences loaded
    When  I go to the speakers page

  Scenario: Speaker admin options are not available
    Then I should not be able to create a new speaker
    And  I should not be able to edit any speakers
    And  I should not be able to delete any speakers

  Scenario: Follow the session and back
    When I open the session for a speaker
    And  I go back to the speaker list
    Then I should be on the speakers page
    
  Scenario: Follow the session info
    When I open the session for a speaker
    Then I should see the session information
    