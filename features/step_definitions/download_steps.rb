Then(/^I clear the dowloaded files$/) do
  clear_downloads
end

Then /^I should see the "([^"]*)" file in downloads folder$/ do |filename|
  #debugger
  wait_for_download
  File.exists?(ENV['DOWNLOAD_DIR']+'/'+filename).should be_true
end