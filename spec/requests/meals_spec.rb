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
  
  describe "GET /api/v1/meals" do
    before do
      FoodDiary.create_days 1
    end
    
    it "Returns all the meals for the current user" do
      get '/api/v1/meals', format: :json
      expect(response).to have_http_status(200)
      expect(response.body).to eq expected
    end
  end

  describe 'POST /api/v1/meals' do
    let(:new_meal) { 
      {'meal' => 'cheese', 'calories' => 1200, 'logged_at' => '2015-09-01T12:30:00.000-05:00'}
    }
    let(:expected) { {'id' => 1}.merge(new_meal).to_json }
    
    context 'When parameters are valid' do
      it 'creates a new meal for the current user' do
        post '/api/v1/meals', format: :json, meal: new_meal
        expect(response).to have_http_status(201)
        expect(response.body).to eq expected
      end
    end
    
    context 'When parameters are invalid' do
      let(:invalid_meal) { 
        {'meal' => '', 'calories' => 1200, 'logged_at' => '2015-09-01T12:30:00.000-05:00'}
      }
      it 'Returns an error' do
        post '/api/v1/meals', format: :json, meal: invalid_meal
        expect(response).to have_http_status(422)
      end
    end
    
  end
  
end
