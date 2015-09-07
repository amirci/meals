require 'rails_helper'

RSpec.describe "Meals API", type: :request do

  describe "GET /api/v1/meals" do
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
    
    before do
      FoodDiary.create_days 1
    end
    
    it "Returns all the meals for the current user" do
      get '/api/v1/meals', format: :json
      expect(response).to have_http_status(200)
      expect(response.body).to eq expected
    end
  end
  
end
