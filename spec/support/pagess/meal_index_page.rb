
module PageObject
  include Capybara::DSL
end

class MealIndexPage 
  include PageObject
  
  def open
    visit '/meals'
  end
  
  def meal_list
    all('.date-reg').map { |n| DayMealsPart.parse n }
  end

  def create_meal(meal)
    find('.new-meal').click
    fill_in 'meal_date', with: meal.logged_at.strftime('%b %d, %Y')
    select meal.logged_at.strftime('%H'), from: 'meal_hours'
    select meal.logged_at.strftime('%M'), from: 'meal_minutes'
    fill_in 'meal_calories', with: meal.calories
    fill_in 'meal_meal', with: meal.meal
    find('.new-meal-form .save').click
  end
  
  def has_empty_notice?
    has_css? '.message'
  end
  
  def self.from_meals(days)
    days.map do |d|
      meals = d.meals.map { |m| DayMealsPart::MealReg.new m.logged_at.strftime('%H:%M'), m.calories, m.meal }
      DayMealsPart.new(d.date, d.calories, meals)
    end
  end

  class DayMealsPart < Struct.new(:day, :total, :meals)
    def self.parse(node)
      DayMealsPart.new parse_date(node), parse_total(node), parse_meals(node)
    end

    private
    class MealReg < Struct.new(:time, :calories, :meal)
    end
    
    def self.parse_meals(node)
      node.all('.meal-reg').map do |mreg|
        MealReg.new(mreg.find('.time').text, mreg.find('.calories').text.to_i, mreg.find('.meal').text)
      end
    end
    
    def self.parse_total(node)
      node.find('.info .total .panel-body').text.to_i
    end
    
    def self.parse_date(node)
      date = node.find('.info .date')
      Date.parse date.find('.day').text + ', ' + date.find('.month').text
    end
  end
  
  
end