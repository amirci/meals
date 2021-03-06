require 'rails_helper'

feature "Adding meals", js: true do
  
  let(:user)  { create(:user) }
  
  let(:meals_page) { MealIndexPage.new }
  
  let!(:old_meals) { FoodDiary.create_days 2, user }
  
  let(:new_meal)   { build :supper, id: 3, meal: 'Chicken with ginger', calories: 2000 }

  before do
    login_as(user, :scope => :user)
    meals_page.open
  end
  
  context 'When confirming' do
    let!(:dialog) { meals_page.begin_create_meal new_meal }
    
    let(:expected) { MealIndexPage.from_meals user }
    
    it "Adds the meal" do
      dialog.save
      
      eventually {
        expect(Meal.all.count).to eq 11
        expect(meals_page.meal_list).to eq expected
        expect(Meal.last.meal).to eq new_meal.meal
      }
    end
    
  end
  
  context 'When cancelling' do
    let!(:dialog) { meals_page.begin_create_meal new_meal }

    let!(:expected) { MealIndexPage.from_meals user }
    
    it "Does not add the meal" do
      dialog.cancel

      expect(meals_page.meal_list).to eq expected
      expect(Meal.all.count).to eq 10
    end
  end
  
end