require 'rails_helper'

feature "Meals Index", js: true, focus: true do
  
  let(:meals_page) { MealIndexPage.new }
  
  context 'When meals exists in the database for the current user' do
    before do
      FoodDiary.create_days 2
    end

    scenario "Lists all the meals" do
      meals_page.open
      
      expected = MealIndexPage.from_meals Meal.totals_by_date.map
      
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