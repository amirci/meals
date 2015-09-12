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

shared_examples_for "only_works_for_current_user" do
  context 'when the meal does not belong to the user' do      
    it 'does not do the op' do
      expect(response).to have_http_status(:unprocessable_entity)
    end
  end
end

shared_examples_for "rejects_unauthorized_access" do
  context 'when not authorized' do
    it "returns unauthorized" do
      expect(response).to have_http_status(:unauthorized)
    end
  end
end

RSpec.configure do |config|
  config.include Devise::TestHelpers, type: :controller
  config.extend ControllerMacros, :type => :controller
end

