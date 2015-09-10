
module Dishes

  @@dishes = [
    'Jambalaya',
    'Chicken Fresco',
    'Smoky Mountain Chicken',
    'Hickory Bourbon Chicken',
    'Chicken Bella',
    'Southern Style Chicken Tender Dinner',
    'Grilled Chicken Salad',
    'Veggie Trio Combo Salad',
    'Garden Bar & Bowl of Soup',
    'Grilled Salmon Caesar Salad',
    'Classic Quesadilla Combo',
    'Jumbo Lump Crab Cake Combo',
    'Carolina Chicken Salad',
    'Classic Cheese Salad',
    'Buffalo Chicken with Blue Cheese',
    'Turkey & Swiss',
    'Reuben Sandwich',
    'Turkey Club',
    'Cajun Jambalaya Pasta',
    'Low Country Shrimp & Grits',
    'Baked Ravioli',
    'Chicken & Mushroom Alfredo',
    'Parmesan Shrimp Pasta',
    'Chicken & Broccoli Pasta',
    'Parmesan Chicken Pasta ',
    'Ruby\'s Classic Burger*',
    'Avocado Turkey Burger',
    'Classic Cheeseburger*',
    'Chicken BLT',
    'Bacon Cheeseburger*',
    'Avocado Grilled Chicken Sandwich',
    'Smokehouse Burger*',
    'Triple Prime Burger*',
    'Triple Prime Cheddar Burger*',
    'Triple Prime Bacon Cheddar Burger*',
    'Turkey Burger',
    'Tortilla a la Espanola'
  ]
  
  def self.dish
    @@dishes.sample
  end
  
  def self.breakfast 
    [
      'Sunny side up eggs',
      'Eggs and Bacon',
      'Huevos Rancheros',
      'Croissant',
      'Toast with jam',
      'Porridge',
      'Western Omellete'
    ].sample
  end
  
  def self.snack
    ['Dried Fruit', 'Nuts', 'Chips', 'Sandwich', 'Smoothie', 'Veggies', 'Fruit'].sample
  end
  
end

module FoodDiary

  def self.create_for(date)
    [:breakfast, :morning_snack, :lunch, :afternoon_snack, :supper].map do |meal|
      FactoryGirl.create meal, date: date
    end
  end
  
  def self.create_days(number)
    number.times { |i| create_for i.days.ago }
  end
  
  def self.populate_month
    create_days 30
  end
  
end

FactoryGirl.define do  
  
  factory :potential_user, class: User do
    email { Faker::Internet.email }
    password "password"
    password_confirmation "password"
    
    factory :user do
    end
  end

  factory :meal do
    transient do
      date { Faker::Date.between(60.days.ago, Date.today) }
    end
    
    meal      { Dishes::dish }
    logged_at { date.in_time_zone }
    calories  { Faker::Number.between(100, 1200) }

    factory :supper do
      after(:build) { |meal| meal.logged_at = meal.logged_at.change(hour: 19, min:00) }
    end

    factory :lunch do
      after(:build) { |meal| meal.logged_at = meal.logged_at.change(hour: 12, min:30) }
    end

    factory :breakfast do
      meal { Dishes::breakfast }
      after(:build) { |meal| meal.logged_at = meal.logged_at.change(hour: 8, min:30) }
    end
    
    factory :morning_snack do
      meal { Dishes::snack }
      after(:build) { |meal| meal.logged_at = meal.logged_at.change(hour: 10, min:00) }
    end

    factory :afternoon_snack do
      meal { Dishes::snack }
      after(:build) { |meal| meal.logged_at = meal.logged_at.change(hour: 15, min:00) }
    end

    factory :invalid_meal do
      meal      nil
    end
  end

end