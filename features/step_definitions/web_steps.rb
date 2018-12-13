module WebStepsHelpers
  def move_jqueryui_slider(window_pos, scroll_pos, sleep_time)
    ##
    # These are the steps helpful to control the slider more elegently
    # if you monitor the page closely, the slider click sets the ul's style value (1st line)
    # and curser div.handle style too (2nd line)
    # so, using page.execute_script to set the ul style
    ##
    # using this slider position can be moved to any point like using mouse move
    # this step can be extentable to the level of mouse scrolling
    page.execute_script("$('div.sliderGallery ul').attr('style', 'left: #{window_pos}')")
    page.execute_script("$('div.handle').attr('style', 'left: #{scroll_pos}')")
    sleep(sleep_time) 
  end
end
World(WebStepsHelpers)

When /^(?:|I )reload the page$/ do
  case Capybara::current_driver
  when :selenium
    visit page.driver.browser.current_url
  # when :racktest
  #   visit [ current_path, page.driver.last_request.env['QUERY_STRING'] ].reject(&:blank?).join('?')
  when :culerity
    page.driver.browser.refresh
  else
    raise "unsupported driver, use rack::test or selenium/webdriver"
  end
end

Given /^test suite is using "([^"]*)" driver$/ do |driver|
  Capybara.current_driver = driver.to_sym
end

Given /^(?:|I am )on the "([^"]*)" page$/ do |url|
 visit(url)
end

Given /^I am on the home page$/ do
  visit('/ncr')
end

Given /^I have entered "([^"]*)" into the "([^"]*)" field$/ do |text, field|
  fill_in field, :with => text
end

When /^I have entered "([^"]*)" into the "([^"]*)" field and press "([^"]*)" key$/ do |text, field, key|
  fill_in field, :with => text
  find_field(field).native.send_key(key.downcase.to_sym)
end

Given /^(?:|I )have entered "([^"]*)" into the "([^"]*)" field and trigger change event$/ do |text, field|
  begin
    fill_in field, :with => text
    trigger_change_event_for_field_id(find(:field, field)['id'])
  rescue Capybara::ElementNotFound
    # try a CSS selector
    f = find(field)
    f.set(text)
    trigger_change_event_for_field_id(f['id'])
  end
end

When /^I click the "([^"]*)" button$/ do |button_text|
  click_button button_text
end

When(/^I click the first button$/) do
 page.first(:xpath, "//button").click
end

When /^(?:|I )click the "([^"]*)" link$/ do |link|
  click_link(link)
end

When /^(?:|I )click the first "([^"]*)" link$/ do |link|
  first(:link, link).click
end

When /^(?:|I )choose "([^"]*)"$/ do |radio_button|
  choose(radio_button)
end

Then /^(?:|I )should see "([^"]*)" is filled with "([^"]*)"$/ do |field, value|
  find_field(field).value.should == value
end

Then /^(?:|I )should see "([^"]*)" is selected with "([^"]*)"$/ do |field, value|
  status = page.has_select?(field, :selected => value).should be_true
end

Then /^(?:|I )should (not )?see "([^"]*)"$/ do |should_not, text|
  if should_not && should_not.present?
    page.should have_no_content(text)
  else
    page.should have_content(text)
  end
end


# image check
Then /^(?:|I )should see "([^"]*)" image$/ do |image|
  page.should have_selector("img[src*=#{image}]")
end

# exact matches
When /^(?:|I )click the button which has text exactly as "([^"]*)"$/ do |button_text|
  page.find(:xpath, "//input[@type='button'][@value='#{button_text}']").click
end

# alerts
When /^(?:|I )have accepted the confirmation dialog$/ do 
  page.driver.browser.switch_to.alert.accept
end

When /^(?:|I )have dismissed the confirmation dialog$/ do
  page.driver.browser.switch_to.alert.dismiss
end

Then /^(?:|I )should see popup message includes "([^"]*)"$/ do |msg|
  page.driver.browser.switch_to.alert.text.should include(msg)
end

Then /^(?:|I )should not see any popup message$/ do
  msg = page.driver.browser.switch_to.alert rescue $!
  msg.to_s.should include('No alert is present')
end

#http://www.quora.com/How-can-I-detect-if-a-popup-new-window-is-open-or-not
#didnt work for alert messages!
Then /^no popups should be open$/ do   
  page.driver.browser.window_handles.length.should == 1
  msgs = page.driver.browser.window_handles.last
end

# pop-up windows
Then /^tests focus on popup window$/ do
  popup = page.driver.browser.window_handles.last
  page.driver.browser.switch_to.window(popup)
end

Then /^(?:|I )close the focused page$/ do
  page.driver.browser.close
end

When /^I press the "([^"]*)" key associated with "([^"]*)"$/ do |key, field|
  #debugger
  find_field(field).native.send_key(key.downcase.to_sym)
end

When /^(?:|I )could move the slider to see all options$/ do 
  #debugger
  sleep_time = 2 # time to see visual effects manually

  # normal slider click step; but it makes approximate move
  page.find(:xpath, "//div[@class='slider ui-slider']").click
  sleep(sleep_time)  
  
  move_jqueryui_slider('0px', '0px', sleep_time)
  move_jqueryui_slider('-468px', '83.5px', sleep_time)
  move_jqueryui_slider('-1207px', '216.5px', sleep_time)
  move_jqueryui_slider('-2028px', '363px', sleep_time)
  move_jqueryui_slider('-1500px', '268px', sleep_time)
  #resetting back
  move_jqueryui_slider('0px', '0px', sleep_time)

end
