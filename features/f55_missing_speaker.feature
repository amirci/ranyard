@f55
Feature: Missing picture for speaker
  As a User
  I want to see  a generic picture for a Speaker when no picture is set
  So I don't see a broken picture/link
  
  Scenario: Show missing picture
    Given I have some conferences loaded
    And   I have a speaker that has no picture
    When  I go to the speakers page
    Then  the missing picture should be shown for the speaker