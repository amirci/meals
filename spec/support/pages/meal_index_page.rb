
module PageObject
  include Capybara::DSL
  
  def handle_js_confirm(accept=true)
      page.execute_script "window.original_confirm_function = window.confirm"
      page.execute_script "window.confirmMsg = null"
      page.execute_script "window.confirm = function(msg) { window.confirmMsg = msg; return #{!!accept}; }"
      yield
  ensure
      page.execute_script "window.confirm = window.original_confirm_function"
  end
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
    all('.date-reg', :visible => true).map { |n| DayMealsPart.parse n }
  end

  def begin_create_meal(meal)
    find('.new-meal').click
    load_meal meal
  end

  def begin_edit_meal(old_meal, new_meal)
    meal_reg = find(:meal_id, old_meal.id)
    meal_reg.hover
    meal_reg.find('.edit').click
    load_meal new_meal, false
  end

  def remove_meal(meal, confirm)
    meal_reg = find(:meal_id, meal.id)
    meal_reg.hover
    handle_js_confirm(confirm) { meal_reg.find('.delete').click }
  end
  
  def has_empty_notice?
    has_css? '.message'
  end
  
  def self.from_meals(days)
    days.map do |d|
      meals = d.meals.map do |m| 
        DayMealsPart::MealReg.new m.id, 
          m.logged_at.strftime('%H:%M'), 
          m.calories, 
          m.meal.strip
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
      page.driver.browser.switch_to.alert.dismiss
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
      meals = parse_meals(node)
      DayMealsPart.new parse_date(node), parse_total(node), meals
    end

    private
    class MealReg < Struct.new(:id, :time, :calories, :meal)
    end
    
    class << self
      def parse_meals(node)
        node.all('.meal-reg', visible: true).map do |mreg|
          time, cal, *meal = mreg.text.split
          MealReg.new mreg[:'data-id'].to_i, 
            Time.parse(time).in_time_zone(Time.zone).strftime('%H:%M'), 
            cal.to_i, 
            meal.join(' ')
        end.sort_by(&:time)
      end
    
      def parse_total(node)
        node.find('.info .total .panel-body').text.to_i
      end
    
      def parse_date(node)
        time = node.find('.meal-reg .time').text.strip
        date = Time.parse(node.find('.info .date').text + ' ' + time)
        date.in_time_zone(Time.zone).to_date
      end
    end
  end
  
  def load_meal(meal, new_meal=true)
    fill_in('meal_date', with: meal.logged_at.strftime('%b %d, %Y')) if new_meal
    select meal.logged_at.strftime('%H'), from: 'meal_hours'
    select meal.logged_at.strftime('%M'), from: 'meal_minutes'
    fill_in 'meal_calories', with: meal.calories
    fill_in 'meal_meal', with: meal.meal
    MealDialog.new
  end
  
end