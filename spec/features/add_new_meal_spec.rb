require 'rails_helper'

feature "Adding meals", js: true do
  
  let(:meals_page) { MealIndexPage.new }
  
  # let!(:old_meals) { create_list :lunch, 2, user: user }
  
  let(:new_meal)   { build :supper, id: 3, meal: 'Chicken with dumplings', calories: 2000 }

  let(:user)  { create(:user) }
  
  before do
    login_as(user, :scope => :user)
    meals_page.open
  end
  
  context 'When confirming', focus: true do
    let!(:dialog) { meals_page.begin_create_meal new_meal }
    
    let(:expected) { MealIndexPage.from_meals Meal.for_user(user).totals_by_date }
    
    it "Adds the meal" do
      dialog.save
      
      eventually {
        expect(meals_page.meal_list).to eq expected
        expect(Meal.all.count).to eq 3
        expect(Meal.last.meal).to eq new_meal.meal
      }
    end
    
  end
  
  context 'When cancelling' do
    let!(:dialog) { meals_page.begin_create_meal new_meal }

    let!(:expected) { MealIndexPage.from_meals Meal.totals_by_date.map }
    
    it "Does not add the meal" do
      dialog.cancel

      expect(meals_page.meal_list).to eq expected
      expect(Meal.all.count).to eq 2
    end
  end
  
end