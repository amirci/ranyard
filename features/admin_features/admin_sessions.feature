Feature: Admin sessions
  As an Admin
  I want to admin sessions
  So I can assign sessions to Speakers
  
  Background:
    Given I have some conferences loaded
    And   I'm logged in as an admin
    And   I go to the sessions page

  Scenario: Adding a new session
    When I add a new session
    Then the new session should appear in the sessions page

  Scenario: Follow link to edit a session
    When I edit a session
    Then the session information should be loaded in the form

  Scenario: Edit a session
    When I edit a session
    And  modify the session values
    Then the updated session should appear in the sessions list

  Scenario: Adding tags to a session
    When I follow "Edit"
    And  I fill in "Tags" with "ruby, code, redbull"
    And  I press "Save Session"
    Then I should see "Session was successfully updated."
    And  I go to the sessions page
    And  I should see "RUBY"
    And  I should see "CODE"
    And  I should see "REDBULL"

  Scenario: Edit a session abstract with markdown
    When I follow "Edit"
    And  I fill in "Abstract" with
    """
    ##Some Session, Eh?

    Awesome *first* session with **examples**
    """
    And  I press "Save Session"
    And  I go to the sessions page
    And  I should see "Some Session, Eh?" with selector "h2"
    And  I should see "first" with selector "em"
    And  I should see "examples" with selector "strong"
    And  I should see "Awesome first session with examples"

  @javascript
  Scenario: Deleting a session
    Given  I delete a session
    Then   the session should not appear in the sessions list
