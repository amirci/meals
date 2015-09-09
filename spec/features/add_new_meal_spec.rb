require 'rails_helper'

RSpec::Matchers.define :match_attributes do |expected|

  match do |actual|
    ajson = actual.to_json(except: [:updated_at, :created_at])
    ejson = expected.to_json(except: [:updated_at, :created_at])
    ajson == ejson
  end
  
end

feature "Adding meals", js: true, focus: true do
  
  let(:meals_page) { MealIndexPage.new }
  
  let!(:old_meals) { create_list :lunch, 2 }
  
  let(:new_meal)   { build :supper, logged_at: Date.tomorrow, meal: 'Chicken with dumplings', calories: 2000 }
  
  before do
    meals_page.open
  end
  
  context 'Adding a new meal' do
    before { meals_page.create_meal new_meal }
    
    it "shows the new meal on page" do
      expected = MealIndexPage.from_meals Meal.totals_by_date
      eventually {
        expect(meals_page.meal_list).to eq expected
        expect(Meal.all.count).to eq 3
        expect(Meal.last.meal).to eq new_meal.meal
      }
    end
    
  end
  
  # context 'Adding a meal but cancelling' do
  #   it "Does not add the mal" do
  #
  #     expected = MealIndexPage.from_meals Meal.totals_by_date.map
  #
  #     expect(meals_page.meal_list).to eq expected
  #   end
  # end
  
end