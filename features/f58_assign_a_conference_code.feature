@f58
Feature: Assign a conference a subdomain code
  As an Admin
  I want to assign a subdomain code (XXX) to each conference
  So users can go to XXX.domain.com see the home of the XXX conference

  Scenario: Going to the home of the top level domain without a subdomain
    Given I have a conference with a name of "winnipeg" hosted at the root domain
    When  I visit the root domain
    Then  I should see the home page for the "winnipeg" conference

  Scenario: Going to the home of the west conference
    Given I have a conference with a code of "west"
    When  I visit the subdomain "west"
    Then  I should see the home page for the "west" conference

