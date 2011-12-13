Feature: Admin Speakers
  As a Admin
  I want to admin speakers
  So I can create, modify or delete speakers

  Background:
    Given I have some conferences loaded
    And   I'm logged in as an admin
    And   I go to the speakers page

    @wip
  Scenario: Adding a new speaker
    When I create a new speaker
    Then the new speaker should appear in the speakers page

    @wip
  Scenario: Follow link to edit a speaker
    When I edit a speaker
    Then the speaker information should be loaded in the form

    @wip
  Scenario: Edit a speaker
    When I edit a speaker
    And  modify the speaker values
    Then the updated speaker should appear in the speakers list
           
   Scenario: Edit a speaker bio using markdown
     When I edit a speaker
     And  modify the speaker bio with
            """
            ##Some Bio, Eh?

            Here is the *first* paragraph of my bio
            """
    Then the displayed speaker bio should have the expected matching HTML

 @javascript
   Scenario: Deleting a speaker
     Given  I delete a speaker
     Then   the speaker should not appear in the speakers list
