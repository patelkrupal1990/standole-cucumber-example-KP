# AfterStep('@pause') do
#   print "Press Return to continue..."
#   STDIN.getc
# end

Before do |scenario|
  Capybara.current_session.driver.browser.manage.window.maximize #if Capybara.current_session.driver.browser.respond_to? :manage
  page.driver.browser.manage.window.maximize

  Capybara::Selenium::Driver.class_eval do
    def reset!
      # Use instance variable directly so we avoid starting the browser just to reset the session
      if @browser
        navigated = false
        start_time = Capybara::Helpers.monotonic_time
        begin
          if !navigated
            # Only trigger a navigation if we haven't done it already, otherwise it
            # can trigger an endless series of unload modals
            begin
              @browser.manage.delete_all_cookies
            rescue Selenium::WebDriver::Error::UnhandledError
              # delete_all_cookies fails when we've previously gone
              # to about:blank, so we rescue this error and do nothing
              # instead.
            end
            @browser.navigate.to("about:blank")
          end
          navigated = true

          #Ensure the page is empty and trigger an UnhandledAlertError for any modals that appear during unload
          until find_xpath("/html/body/*").empty? do
            # raise Capybara::ExpectationNotMet.new('Timed out waiting for Selenium session reset') if (Capybara::Helpers.monotonic_time - start_time) >= 10
            return if (Capybara::Helpers.monotonic_time - start_time) >= 10
            sleep 0.05
          end
        rescue Selenium::WebDriver::Error::UnhandledAlertError
          # This error is thrown if an unhandled alert is on the page
          # Firefox appears to automatically dismiss this alert, chrome does not
          # We'll try to accept it
          begin
            @browser.switch_to.alert.accept
            sleep 0.25 # allow time for the modal to be handled
          rescue Selenium::WebDriver::Error::NoAlertPresentError
            # The alert is now gone - nothing to do
          end
          # try cleaning up the browser again
          retry
        end
      end
    end

  end

end




