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

module RequestMacros
  include Rails.application.routes.url_helpers
  
  def it_rejects_unauthorized_access(url)
    context 'when not authorized' do
      it "returns unauthorized" do
        get url, format: :json
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, :type => :controller
  config.extend RequestMacros, :type => :request
end

