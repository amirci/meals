require 'capybara/poltergeist'
Capybara.javascript_driver = :poltergeist

# Capybara.register_driver :selenium do |app|
#   Capybara::Driver::Selenium
#
#   profile = Selenium::WebDriver::Firefox::Profile.new
#   profile.enable_firebug
#
#   Capybara::Driver::Selenium.new(app, { :browser => :firefox, :profile => profile })
# end


module AsyncHelper
  EXCEPTIONS = [RSpec::Expectations::ExpectationNotMetError, StandardError]
  
  def eventually(options = {})
    timeout = options[:timeout] || 2
    interval = options[:interval] || 0.1
    time_limit = Time.now + timeout
    loop do
      begin
        yield
      rescue *EXCEPTIONS => error
      end
      return if error.nil?
      raise error if Time.now >= time_limit
      sleep interval
    end
  end
end

RSpec.configure do |config|
  config.include AsyncHelper
  
end
