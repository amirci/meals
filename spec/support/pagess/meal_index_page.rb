
module PageObject
  include Capybara::DSL
end

Capybara.add_selector(:meal_id) do
  xpath { |id| XPath.css(".meal-reg[data-id='#{id}']") }
end

class MealIndexPage 
  include PageObject
  
  def open
    visit '/meals'
  end
  
  def meal_list
    all('.date-reg').map { |n| DayMealsPart.parse n }
  end

  def begin_create_meal(meal)
    find('.new-meal').click
    load_meal meal
  end

  def begin_edit_meal(old_meal, new_meal)
    meal_reg = find(:meal_id, old_meal.id)
    meal_reg.hover
    meal_reg.find('.edit').click
    load_meal new_meal
  end

  def begin_remove_meal(meal)
    meal_reg = find(:meal_id, meal.id)
    meal_reg.hover
    meal_reg.find('.delete').click
    ConfirmDialog.new
  end
  
  def has_empty_notice?
    has_css? '.message'
  end
  
  def self.from_meals(days)
    days.map do |d|
      meals = d.meals.map do |m| 
        DayMealsPart::MealReg.new m.id, m.logged_at.strftime('%H:%M'), m.calories, m.meal
      end
      DayMealsPart.new(d.date, d.calories, meals)
    end
  end

  class ConfirmDialog
    include PageObject
    
    def confirm
      page.driver.browser.switch_to.alert.accept
    end
    
    def cancel
      page.driver.browser.switch_to.alert.cancel
    end
  end
  
  class MealDialog
    include PageObject
  
    def save
      find('.new-meal-form .save').trigger('click')
    end
    
    def cancel
      find('.new-meal-form .cancel').trigger('click')
    end
  end
  
  class DayMealsPart < Struct.new(:day, :total, :meals)
    def self.parse(node)
      DayMealsPart.new parse_date(node), parse_total(node), parse_meals(node)
    end

    private
    class MealReg < Struct.new(:id, :time, :calories, :meal)
    end
    
    class << self
      def parse_meals(node)
        node.all('.meal-reg').map do |mreg|
          MealReg.new(mreg[:'data-id'].to_i, mreg.find('.time').text, mreg.find('.calories').text.to_i, mreg.find('.meal').text)
        end
      end
    
      def parse_total(node)
        node.find('.info .total .panel-body').text.to_i
      end
    
      def parse_date(node)
        date = node.find('.info .date')
        Date.parse date.find('.day').text + ', ' + date.find('.month').text
      end
    end
  end
  
  def load_meal(meal)
    fill_in 'meal_date', with: meal.logged_at.strftime('%b %d, %Y')
    select meal.logged_at.strftime('%H'), from: 'meal_hours'
    select meal.logged_at.strftime('%M'), from: 'meal_minutes'
    fill_in 'meal_calories', with: meal.calories
    fill_in 'meal_meal', with: meal.meal
    MealDialog.new
  end
  
end