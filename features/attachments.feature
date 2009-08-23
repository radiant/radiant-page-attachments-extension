Feature: attachments
  As a content editor
  I should be able to add, reorder, and delete attachments
  
  Background:
    Given I am logged in as admin
  
  Scenario: attach a file
    Given I have a page with no attachments
    When I edit the page
    And I click the plus icon
    And I attach the Rails logo
    And I save
    Then the page should have a new attachment
  
  Scenario: don't change attachments
    Given I have a page with 2 attachments
    When I edit the page
    And I save
    Then the page should have 2 attachments
  
  Scenario: attach another file
    Given I have a page with 2 attachments
    When I edit the page
    And I click the plus icon
    And I attach the Rails logo
    And I save
    Then the page should have 3 attachments
  
  Scenario: delete a file
    Given I have a page with 2 attachments
    When I edit the page
    And I delete the first attachment
    And I save
    Then the page should have 1 attachment
  
  Scenario: reorder attachments
    Given I have a page with 2 attachments
    When I edit the page
    And I drag attachment 2 above attachment 1
    And I save
    Then attachment 2 should be in position 1