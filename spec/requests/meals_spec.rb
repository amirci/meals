require 'rails_helper'

RSpec.describe "Meals API", type: :request do

  let(:expected) do
    JSON.parse Meal.for_user(user).to_json(except: [:created_at, :updated_at, :user_id])
  end
  
  let(:user) { create :user }

  let(:headers) { {'X-User-Email' => user.email, 'X-User-Token' => user.authentication_token} }

  let!(:other_meal) { create :breakfast, user: create(:user) }
  
  describe "GET /api/v1/meals" do
    before {FoodDiary.create_days 1, user}
    let(:actual) { JSON.parse response.body }
    it_behaves_like 'rejects_unauthorized_access' do
      before { get api_v1_meals_path }
    end
    
    it "Returns all the meals for the current user" do
      get api_v1_meals_path, {format: :json}, headers
      expect(response).to have_http_status(:ok)
      expect(actual).to eq expected
    end
  end

  describe 'DELETE /api/v1/meals/:id' do
    let!(:meal)     { create :lunch , user: user }
    let!(:old_meal) { create :supper, user: user }
    
    it_behaves_like 'rejects_unauthorized_access' do
      before { delete api_v1_meal_path(meal) }
    end

    it_behaves_like 'only_works_for_current_user' do
      before { delete api_v1_meal_path(other_meal), {format: :json}, headers }
    end
    
    context 'when the meal exists' do
      it 'removes the meal' do
        delete api_v1_meal_path(meal), {format: :json}, headers
        expect(response).to have_http_status(:ok)
        expect(Meal.for_user user).to eq [old_meal]
      end
    end
    
    context 'when the meal does not exist' do
      it 'removes the meal' do
        delete api_v1_meal_path(10), {format: :json}, headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end
  
  describe 'PUT /api/v1/meals/:id'  do
    let!(:meal)    { create :lunch, meal: 'Shrimp & lobster', user: user }
    let(:new_meal) { build(:supper).attributes }
    
    it_behaves_like 'rejects_unauthorized_access' do
      before { put api_v1_meal_path(meal) }
    end

    it_behaves_like 'only_works_for_current_user' do
      before { put api_v1_meal_path(other_meal), {:format => :json, meal: new_meal}, headers }
    end

    context 'When parameters are valid' do
      let(:last_meal) do
        Meal.for_user(user).last.to_json(except: [:created_at, :updated_at, :user_id])
      end
      let(:expected) { new_meal.merge('id' => 2).to_json(except: ['created_at', 'updated_at', 'user_id']) }

      it 'The meal gets updated' do
        put api_v1_meal_path(meal), {:format => :json, meal: new_meal}, headers
        expect(response).to have_http_status(:ok)
        expect(last_meal).to eq expected
      end
    end
    
    context 'When parameters are not valid' do
      let(:invalid_meal) { attributes_for :invalid_meal }
      it 'Updates the meal with new values' do
        put api_v1_meal_path(meal), {:format => :json, meal: invalid_meal}, headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end

  end
  
  describe 'POST /api/v1/meals' do
    let(:new_meal) { build(:lunch).attributes }
    let(:expected) { new_meal.merge('id' => 2).to_json(except: ['created_at', 'updated_at', 'user_id']) }
    
    it_behaves_like 'rejects_unauthorized_access' do
      before { post api_v1_meals_path }
    end

    context 'When parameters are valid' do
      let(:last_meal) do
        Meal.for_user(user).last.to_json(except: [:created_at, :updated_at, :user_id])
      end
      
      it 'creates a new meal for the current user' do
        post api_v1_meals_path, {:format => :json, meal: new_meal}, headers
        expect(response).to have_http_status(:created)
        expect(last_meal).to eq expected
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
