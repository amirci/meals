require 'rails_helper'

RSpec.describe Api::V1::SessionsController, type: :request, focus: true do

  let(:pwd)  { 'bananascoladas' }
  let(:user) { create :user, password: pwd, password_confirmation: pwd, calories: 1000 }

  let(:expected) { {'login' => {'token' => user.authentication_token} }}
  let(:headers) { {'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token} }
  
  # logout to the API
  describe 'DELETE /api/v1/logins' do
    
    context 'when using the right credentials' do
      it 'resets the token for the user' do
        delete api_v1_session_path, {:format => :json}, headers 
        expect(response).to have_http_status(:ok)
      
        user.reload
      
        expect(user.authentication_token).to eq 'something'
      end
    end

    context 'when having the wrong credentials' do
      it 'resets the token for the user' do
        delete api_v1_session_path, {:format => :json}
        expect(response).to have_http_status(:unauthorized)
      end
    end
    
  end

  # login to the API
  describe 'POST /api/v1/logins' do

    context 'when the parameters exist' do
      it 'returns a token to login' do
        post api_v1_session_path, :format => :json, user: {email: user.email, password: pwd}
        expect(response).to have_http_status(:ok)
        expect(JSON.parse response.body).to eq expected
      end
    end
    
    context 'when the parameters are wrong' do
      it 'returns unauthorized' do
        post api_v1_session_path, :format => :json, user: {email: user.email, password: 'crazyotherpwd'}
        expect(response).to have_http_status(:unauthorized)
      end
    end
  end
  

end
