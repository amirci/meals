require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

# Capybara.register_driver :selenium do |app|
#   Capybara::Driver::Selenium
#
#   :profile = Selenium::WebDriver::Firefox::Profile.new
#   profile.enable_firebug
#
#   Capybara::Driver::Selenium.new(app, { :browser => :firefox, :profile => profile })
# end