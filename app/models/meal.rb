class Meal < ActiveRecord::Base
  
  def self.totals_by_date
    all
      .group_by { |m| m.logged_at.to_date }
      .to_a
      .map do |date, meals|
        DayMeals.new(date, meals.sum(&:calories), meals.sort_by(&:logged_at))
      end
  end
  
end


DayMeals = Struct.new(:date, :calories, :meals)
