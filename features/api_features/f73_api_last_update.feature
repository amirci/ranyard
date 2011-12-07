Feature: API for last change done to the data
  As a developer
  I want to get the date of the last update
  So I can refresh the data only when needed
  
  Scenario Outline: Getting last update
    Given the data has been modified on "<some_date>"
    When  I query the API to get the last update
    Then  I JSON API last update should be "<some_date>"
    
    Examples:
      | some_date    |
      | Nov 21, 2011 |
      | Jan  1, 2010 |
      | Feb 27, 2020 |
      