require 'rails_helper'

RSpec.describe "Meals API", type: :request do

  describe "GET /api/v1/meals" do
    before do
      create_list :meal, 10
    end
    
    it "Returns all the meals for the current user" do
      get '/api/v1/meals', format: :json
      expect(response).to have_http_status(200)
      expect(response.body).to eq Meal.all.to_json(except: [:created_at, :updated_at])
    end
  end
  
end
