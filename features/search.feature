@default
Feature: Search
  In order to find pages on the web
  As an information seeker
  I want to be able to search using keywords

Scenario: Search for cucumber
  Given I am on the home page
  When I have entered "cucumber bdd" into the "q" field and press "Return" key
  Then I should see "Cucumber - Making BDD fun"

Scenario: Slider move
  Given I am on the "http://jqueryfordesigners.com/demo/slider-gallery.html" page
  Then I could move the slider to see all options

