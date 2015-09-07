require 'rails_helper'

feature "Lists all the meals for the current user", js: true do
  
  context 'When meals exists in the database for the current user' do
    before :each do
      FoodDiary.create_days 2
    end

    let(:meals_page) { MealIndexPage.new }
    
    scenario "Lists all the meals" do
      byebug

      meals_page.open
      
      byebug

      expected = Meal.totals_by_date
      
      expect(meals_page.meal_list).to eq expected
    end
  end
  
  # context 'When no meals are available' do
  #   it 'shows an empty list message' do
  #     visit '/meals'
  #
  #     actual = all('.meal')
  #
  #     expect(actual).to be_empty
  #   end
  # end
  
end