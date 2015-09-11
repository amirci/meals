require 'rails_helper'

feature "Meals Index", js: true do
  
  let(:meals_page) { MealIndexPage.new }
  
  let(:user)  {create(:user)}

  before do
    login_as(user, :scope => :user)
  end
  
  context 'When meals exists in the database for the current user' do
    before do
      FoodDiary.create_days 2, user: user
    end

    scenario "Lists all the meals" do
      meals_page.open
      
      expected = MealIndexPage.from_meals Meal.for_user(user).totals_by_date
      
      expect(meals_page.meal_list).to eq expected
    end
  end
  
  context 'When no meals are available' do
    it 'Shows an empty list message' do
      meals_page.open

      actual = meals_page.meal_list

      expect(actual).to be_empty
      
      expect(meals_page).to have_empty_notice
    end
  end
  
end