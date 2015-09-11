require 'rails_helper'

RSpec.describe MealsController, type: :controller do

  let(:valid_attributes)   { attributes_for :meal }

  let(:invalid_attributes) { attributes_for :invalid_meal }

  let(:valid_session) { {} }

  login_user
  
  describe "GET #index" do
    before do
      FoodDiary.create_days 1, user
      FoodDiary.create_days 1, create(:user)
    end
    
    it "assigns all meals grouped by date @meals for the current user" do
      meals = Meal.for_user(user).totals_by_date
      get :index, {}, valid_session
      expect(assigns(:meals)).to eq meals
    end
  end


end
