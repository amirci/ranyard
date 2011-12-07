Feature: Admin Conferences
  As an Admin
  I want to create a Conference
  So I can add speakers and sessions

  Background:
    Given I have some conferences loaded
    And   I'm logged in as an admin
    And   I go to the conferences page

  Scenario: Listing conferences
    Then I should see all the conferences listed
    
  Scenario: Adding a new Conference
    When  I create a new conference
    Then  the new conference should appear in the conference listing

  @javascript
  Scenario: Deleting a Conference
   Given I confirm the confirmation dialog 
    When I press "Delete Conference"
    And  I go to the conferences page
    Then I should not see "C1"
    And  I should not see "Jul 1, 2011"
    And  I should not see "Jul 3, 2011"

  Scenario: Follow link to edit a conference
    When I edit the first conference
    Then the conference fields should be loaded

  Scenario: Edit a conference
    When I edit the first conference
    And  I save new conference data
    Then the conference should be updated
    
  
    