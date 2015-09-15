require 'rails_helper'

feature "Removing meals", js: true do
  
  let(:meals_page) { MealIndexPage.new }
  
  let!(:meals)     { create_list :lunch, 2, user: user }
  
  let(:meal)       { meals.last }
  
  let(:user)  {create(:user)}
  before do
    login_as(user, :scope => :user)
    meals_page.open
  end
  
  context 'When confirming' do
    let(:expected) { MealIndexPage.from_meals user }
    
    it "Removes the meal" do
      meals_page.remove_meal meal, true
      
      eventually {
        expect(meals_page.meal_list).to eq expected
        expect(Meal.all.count).to eq 1
        expect(Meal.find_by_id meal.id).to be_nil
      }
    end
    
  end
  
  context 'When cancelling' do
    let!(:expected) { MealIndexPage.from_meals user }
    
    it "Does not remove the meal" do
      meals_page.remove_meal meal, false

      expect(meals_page.meal_list).to eq expected
      expect(Meal.all.count).to eq 2
    end
  end
  
end