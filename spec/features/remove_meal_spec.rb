require 'rails_helper'

feature "Removing meals", js: true, selenium: true do
  
  let(:meals_page) { MealIndexPage.new }
  
  let!(:meals)     { create_list :lunch, 2 }
  
  let(:meal)   { meals.last }
  
  before do
    meals_page.open
  end
  
  context 'When confirming', focus: true do
    let!(:dialog) { meals_page.begin_remove_meal meal }
    
    let(:expected) { MealIndexPage.from_meals Meal.totals_by_date.map }
    
    it "Removes the meal" do
      dialog.confirm
      
      eventually {
        expect(meals_page.meal_list).to eq expected
        expect(Meal.all.count).to eq 1
        expect(Meal.find_by_id meal.id).to be_null
      }
    end
    
  end
  
  context 'When cancelling' do
    let!(:dialog) { meals_page.begin_remove_meal meal }

    let!(:expected) { MealIndexPage.from_meals Meal.totals_by_date.map }
    
    it "Does not remove the meal" do
      dialog.cancel

      expect(meals_page.meal_list).to eq expected
      expect(Meal.all.count).to eq 2
    end
  end
  
end