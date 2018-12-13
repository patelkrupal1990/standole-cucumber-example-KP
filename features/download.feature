Feature: Download
  To demonstrate download feature
   
Scenario: Downloading the standalone-cuke-selenium-download zip file
  Given I am on the "https://github.com/sivajankan/standalone-cuke-selenium-download" page
  When I click the "ZIP" link
  Then I should see the "standalone-cuke-selenium-download-master.zip" file in downloads folder
