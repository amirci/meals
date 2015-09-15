require 'rails_helper'

feature "Edit meal", js: true do
  
  let(:meals_page) { MealIndexPage.new }
  
  let(:meal)     { create :lunch, user: user, meal: 'Chicken Pomodoro', calories: '2200' }
  
  let!(:meals)   { [meal] }
  
  let(:new_meal) { build :supper, meal: 'Steak & fries', calories: '1500', date: meal.logged_at }
  
  let(:user)     { create :user }
  
  before do
    login_as(user, :scope => :user)
    meals_page.open
  end
  
  context 'When confirming' do
    let!(:dialog) { meals_page.begin_edit_meal meal, new_meal }
    
    let(:expected) { MealIndexPage.from_meals user }
    
    it "Changes the meal information" do
      dialog.save
      
      wait_for_ajax
      
      eventually {
        expect(meals_page.meal_list).to eq expected
        expect(Meal.last.meal).to eq new_meal.meal
      }
    end
    
  end
  
  context 'When cancelling' do
    let!(:dialog) { meals_page.begin_edit_meal meal, new_meal }

    let!(:expected) { MealIndexPage.from_meals user }
    
    it "Does not change the meal information" do
      dialog.cancel

      eventually {
        expect(meals_page.meal_list).to eq expected
      }
    end
  end
  
end