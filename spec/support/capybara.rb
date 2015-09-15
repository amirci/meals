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

  def wait_until(timeout = Capybara.default_wait_time)
    Timeout.timeout(timeout) do
      sleep(0.1) until value = yield
      value
    end
  end
    
  def wait_for_ajax(timeout = Capybara.default_wait_time)
    wait_until(timeout) do
      return if page.evaluate_script('typeof jQuery == "undefined"') # if jQuery isn't loaded then doesn't make sense to check for ajax request termination
      if Capybara.current_driver.to_s.starts_with? 'selenium'
        page.evaluate_script 'jQuery.active <= 1' #selenium keeps reporting an active connection anyway
      else
        page.evaluate_script 'jQuery.active == 0'
      end
    end
  end  
end

RSpec.configure do |config|
  config.include AsyncHelper
  
end
