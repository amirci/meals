require 'devise'

module ControllerMacros
#   def login_admin
#     before(:each) do
#       @request.env["devise.mapping"] = Devise.mappings[:admin]
#       sign_in FactoryGirl.create(:admin) # Using factory girl as an example
#     end
#   end
#
  def login_user
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in user
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, :type => :controller
end

