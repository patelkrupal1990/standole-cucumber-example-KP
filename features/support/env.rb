# begin require 'rspec/expectations'; rescue LoadError; require 'spec/expectations'; end
require 'capybara' 
require 'capybara/dsl' 
require 'capybara/cucumber'
require 'launchy'
require 'capybara/rspec'
require 'selenium/webdriver'

require "rubygems"




require 'cucumber/formatter/unicode' # Remove this line if you don't want Cucumber Unicode support
require 'cucumber/formatter/html'
#require 'cucumber/rails/rspec'
#require 'cucumber/rails/active_record'
#require 'cucumber/web/tableish'

require 'capybara/cucumber'
require 'capybara/session'
require 'capybara-screenshot/cucumber'




ENV['ROOT_DIR'] = Dir.pwd
ENV['DOWNLOAD_DIR'] = "#{ENV['ROOT_DIR']}/tmp/downloads"

# Capybara.register_driver :selenium do |app|
#   profile = Selenium::WebDriver::Firefox::Profile.new
#   profile['browser.download.folderList'] = 2
#   profile['browser.download.manager.showWhenStarting'] = false
#   profile['browser.download.manager.useWindow'] = false
#   profile['browser.download.useDownloadDir'] = true
#   profile['browser.download.dir'] = ENV['DOWNLOAD_DIR']
#   profile['browser.helperApps.neverAsk.saveToDisk'] = "application/x-tar,application/g-zip,application/zip,application/csv,application/excel,text/csv"
#   #avoid print dialogs
#   profile['capability.policy.default.Window.print'] = "noAccess"
#   Capybara::Selenium::Driver.new(app, :profile => profile)
# end

Capybara.register_driver :selenium do |app|
  profile = Selenium::WebDriver::Firefox::Profile.new
  profile.assume_untrusted_certificate_issuer = false
  profile.secure_ssl = false
  profile['security.mixed_content.block_active_content'] = false
  profile['security.mixed_content.block_display_content'] = true
  profile['browser.download.folderList'] = 2 #custom location
  # profile['browser.download.dir'] = DownloadHelper::PATH.to_s
  profile['browser.helperApps.neverAsk.saveToDisk'] = 'text/plain,text/html,application/vnd.openxmlformats-officedocument.spreadsheetml.sheet'
  profile['browser.manage.timeouts.implicit_wait'] = 100
  profile['browser.download.dir'] = ENV['DOWNLOAD_DIR']
  profile['browser.manage.timeouts.script_timeout'] = 100
  profile['browser.manage.timeouts.read_timeout'] = 500
  profile['browser.manage.timeouts.page_load'] = 120
  profile['datareporting.healthreport.service.enabled'] = false
  profile['xpinstall.signatures.required'] = false
  profile['datareporting.healthreport.uploadEnabled'] =  false
  profile['datareporting.healthreport.service.firstRun'] =  false
  Capybara::Selenium::Driver.new(app, :profile => profile)
end


#
# capabilities = Selenium::WebDriver::Remote::W3C::Capabilities.firefox(accept_insecure_certs: true)
# driver = Selenium::WebDriver.for :firefox, desired_capabilities: :capabilities

Capybara.default_driver = :selenium

# Capybara.register_driver :remote_ie do |app|
#   Capybara::Selenium::Driver.new(app,
#                                  :browser => :remote,
#                                  :url => "http://##IEMACHINEIP##:4444/wd/hub",
#                                  :desired_capabilities => :internet_explorer)
# end

# Capybara.register_driver :selenium_chrome do |app|
#   Capybara::Selenium::Driver.new(app, browser: :chrome)
# end
#
# Capybara.register_driver :selenium_safari do |app|
#   debugger
#   Capybara::Selenium::Driver.new(app, browser: :safari)
# end
#
# Capybara.register_driver :chrome_ext do |app|
#   args = []
#   args << "--window-size=1024,768"
#
#   profile = Selenium::WebDriver::Chrome::Profile.new
#   profile["download.prompt_for_download"] = false
#   profile["download.default_directory"] = ENV['DOWNLOAD_DIR']
#
#   chrome_switches = %w[--ignore-certificate-errors --disable-popup-blocking --disable-translate]
#   caps_opts = {'chrome.switches' => chrome_switches}
#   cap = Selenium::WebDriver::Remote::Capabilities.chrome caps_opts
#
#   Capybara::Selenium::Driver.new(app, browser: :chrome, desired_capabilities: cap, args: args)
# end

Capybara.app_host = 'http://www.google.com'
Capybara.default_max_wait_time = 2


# if ENV['BROWSER']
#   if ENV['BROWSER'].downcase == 'ie'
#     Capybara.default_driver = :remote_ie
#   elsif ENV['BROWSER'].downcase == 'chrome'
#     Capybara.default_driver = Capybara.javascript_driver = :selenium_chrome
#   elsif ENV['BROWSER'].downcase == 'chrome_ext'
#     #debugger
#     Capybara.default_driver = Capybara.javascript_driver = :chrome_ext
#   elsif ENV['BROWSER'].downcase == 'safari'
#     Capybara.default_driver = :selenium_safari
#   else
#     Capybara.default_driver = :selenium
#   end
# end

# #IE Config
# Capybara.register_driver :selenium do |app|
#   Capybara::Selenium::Driver.new(app,
#     :browser => :remote,
#     :url => "http://172.16.80.115:4444/wd/hub",
#     :desired_capabilities => :internet_explorer)
# end

Capybara.configure do |config|
  config.match = :one
  config.exact_options = true
  config.ignore_hidden_elements = true
  config.visible_text_only = true
end

World(Capybara)
