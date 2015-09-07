
module PageObject
  include Capybara::DSL
end

class MealIndexPage 
  include PageObject
  
  def open
    visit '/meals'
  end
  
  def meal_list
    actual = all('.date-reg').map do |node|
      date = node.find('.info .date')
      total = node.find('.info .total .panel-body').text
      DayMeals.new parse_date(date), 0, []
    end
  end
  
  private
  def parse_date(node)
    Date.today
  end
end