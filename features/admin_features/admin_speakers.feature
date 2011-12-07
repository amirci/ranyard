Feature: Admin Speakers
  As a Admin
  I want to admin speakers
  So I can create, modify or delete speakers

  Background:
    Given I have some conferences loaded
    And   I'm logged in as an admin
    And   I go to the speakers page

  Scenario: Adding a new speaker
    When  I create a new speaker
    Then  the new speaker should appear in the speakers page

  Scenario: Follow link to edit a speaker
    When I edit a speaker
    Then the speaker information should be loaded in the form

  Scenario: Edit a speaker
     When I follow "Edit"
     And  I fill in "Name" with "Soso Presenter"
     And  I fill in "Email" with "soso@pres.com"
     And  I fill in "Twitter" with "sosotweet"
     And  I fill in "Blog" with "sblog"
     And  I fill in "Website" with "www.soso"
     And  I fill in "Picture" with "soso.jpg"
     And  I fill in "Location" with "San Francisco, CA"
     And  I fill in "Bio" with "I'm soso, so boring and so much fun!"
     And  I press "Save"
     Then I should see "Speaker was successfully updated."
     And  I go to the speakers page
     And  I should see "Soso Presenter"
     And  I should see "San Francisco, CA"
     And  I should see "I'm soso, so boring and so much fun!"
     And  I should have the following mails:
           | email         | 
           | soso@pres.com | 
     And  I should have the following links:
           | blog         | website         | twitter                          | 
           | http://sblog | http://www.soso | http://www.twitter.com/sosotweet |
     And  I should have the following images:
           | picture           |
           | speakers/soso.jpg |
           
   Scenario: Edit a speaker bio using markdown
     When I follow "Edit"
     And  I fill in "Bio" with 
            """
            ##Some Bio, Eh?

            Here is the *first* paragraph of my bio
            """
     And  I press "Save"
     Then I should see "Speaker was successfully updated."
     And  I go to the speakers page
     And  I should see "Here is the first paragraph of my bio"
     And  I should see "Some Bio, Eh?" with selector "h2"
     And  I should see "first" with selector "em"

 @javascript
   Scenario: Deleting a speaker
    Given I confirm the confirmation dialog 
     When I press "Delete"
     And  I go to the speakers page
     Then I should not see "A Presenter"
     And  I should not see "Winnipeg, MB"
     And  I should not see "I'm very good, I present all the time"
     And  I should not have the following mails:
           | email         | 
           | good@pres.com | 
     And  I should not have the following links:
           | blog         | website          | twitter                      | 
           | http://gblog | http://www.goody | http://www.twitter.com/goody |
     And  I should not have the following images:
           | picture   |
           | speakers/goody.jpg |
           
     