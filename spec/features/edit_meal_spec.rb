require 'rails_helper'

feature "Edit meal", js: true do
  
  let(:meals_page) { MealIndexPage.new }
  
  let(:meal)     { create :lunch, meal: 'Chicken Pomodoro', calories: '2200' }
  
  let!(:meals)   { [meal] }
  
  let(:new_meal) { build :supper, meal: 'Steak & fries', calories: '1500', date: meal.logged_at }
  
  before do
    user = create(:user)
    login_as(user, :scope => :user)
    meals_page.open
  end
  
  context 'When confirming' do
    let!(:dialog) { meals_page.begin_edit_meal meal, new_meal }
    
    let(:expected) { MealIndexPage.from_meals Meal.totals_by_date.map }
    
    it "Changes the meal information" do
      dialog.save
      
      eventually {
        expect(meals_page.meal_list).to eq expected
        expect(Meal.last.meal).to eq new_meal.meal
      }
    end
    
  end
  
  context 'When cancelling' do
    let!(:dialog) { meals_page.begin_edit_meal meal, new_meal }

    let!(:expected) { MealIndexPage.from_meals Meal.totals_by_date.map }
    
    it "Does not change the meal information" do
      dialog.cancel

      eventually {
        expect(meals_page.meal_list).to eq expected
      }
    end
  end
  
end