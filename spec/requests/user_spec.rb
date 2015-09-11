require 'rails_helper'

RSpec.describe "User API", :type => :request, focus: true do

  let(:user) { create :user, calories: 1000 }

  let(:headers) { {'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token} }

  describe 'PUT /api/v1/user/:id' do
    it 'updates the user configuration' do
      put api_v1_user_path(user), {format: :json, config: {calories: 1500}}, headers
      expect(response).to have_http_status(:ok)
      expect(User.first.calories).to eq 1500
    end
  end
  
end
