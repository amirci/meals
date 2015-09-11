require 'rails_helper'

RSpec.describe "Meals API", type: :request do

  let(:expected) do
    Meal.totals_by_date.map do |day_meals|
      {
        'date'     => day_meals.date, 
        'calories' => day_meals.calories,
        'meals'    => day_meals.meals.map do |m| 
          {
            'time' => m.logged_at.strftime('%H:%M'),
            'meal' => m.meal, 
            'calories' => m.calories
          }
        end
      }
    end.to_json
  end
  
  let(:user) { create :user }

  let(:headers) { {'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token} }

  describe "GET /api/v1/meals" do
    before {FoodDiary.create_days 1}

    it_rejects_unauthorized_access '/api/v1/meals'
    
    it "Returns all the meals for the current user" do
      get api_v1_meals_path, {format: :json}, headers
      expect(response).to have_http_status(:ok)
      expect(response.body).to eq expected
    end
  end

  describe 'DELETE /api/v1/meals/:id' do
    let!(:meal)     { create :lunch }
    let!(:old_meal) { create :supper }
    
    context 'when the meal exists' do
      it 'removes the meal' do
        delete api_v1_meal_path(meal), {format: :json}, headers
        expect(response).to have_http_status(:no_content)
        expect(Meal.all).to eq [old_meal]
      end
    end
    
    context 'when the meal does not exist' do
      it 'removes the meal' do
        delete api_v1_meal_path(3), {format: :json}, headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  
  describe 'PUT /api/v1/meals/:id' do
    let!(:meal)    { create :lunch, meal: 'Shrimp & lobster' }
    let(:new_meal) { attributes_for(:supper) }
    let(:expected) { JSON.parse({'id' => meal.id}.merge(new_meal).to_json) }
    
    context 'When parameters are valid' do
      it 'Updates the meal with new values' do
        put api_v1_meal_path(meal), {:format => :json, meal: new_meal}, headers
        expect(response).to have_http_status(:ok)
        expect(JSON.parse response.body).to eq expected
      end
    end
    
    context 'When parameters are valid' do
      let(:invalid_meal) { attributes_for :invalid_meal }
      it 'Updates the meal with new values' do
        put api_v1_meal_path(meal), {:format => :json, meal: invalid_meal}, headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end
  
  describe 'POST /api/v1/meals' do
    let(:new_meal) { attributes_for :lunch }
    let(:expected) { JSON.parse({'id' => 1}.merge(new_meal).to_json) }
    
    context 'When parameters are valid' do
      it 'creates a new meal for the current user' do
        post api_v1_meals_path, {:format => :json, meal: new_meal}, headers
        expect(response).to have_http_status(:created)
        expect(JSON.parse response.body).to eq expected
      end
    end
    
    context 'When parameters are invalid' do
      let(:invalid_meal) { attributes_for :invalid_meal }

      it 'Returns an error' do
        post api_v1_meals_path, {format: :json, meal: invalid_meal}, headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
    
  end
  
end
