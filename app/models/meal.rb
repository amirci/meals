class Meal < ActiveRecord::Base

  validates_presence_of :meal, :logged_at, :calories
  validates_numericality_of :calories, only_integer: true, greater_than: 0
  
  def self.totals_by_date
    all
      .group_by { |m| m.logged_at.to_date }
      .to_a
      .map do |date, meals|
        DayMeals.new(date, meals.sum(&:calories), meals.sort_by(&:logged_at))
      end
      .sort { |a, b| b.date <=> a.date }
  end
  
end


DayMeals = Struct.new(:date, :calories, :meals)
