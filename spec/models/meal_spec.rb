require 'rails_helper'

RSpec.describe Meal, type: :model do
  
  context 'Required fields' do
    
    describe 'Meal is required' do
    end
    
    describe 'Calories is required' do
    end
    
    describe 'Logged at is required' do
    end
    
  end
  
  context 'Scopes' do
    
    describe '.totals_by_date' do
      let(:date)   { 1.day.ago }
      let(:date2)  { 2.day.ago }
      let(:actual) { Meal.totals_by_date }
      let!(:yesterday) {
        [
          create(:breakfast, calories: 100, date: date),
          create(:lunch    , calories: 300, date: date),
          create(:supper   , calories: 400, date: date)
        ]
      }
      let!(:another_day) {
        [
          create(:breakfast, calories: 200, date: date2),
          create(:lunch    , calories: 200, date: date2),
          create(:supper   , calories: 200, date: date2)
        ]
      }
      
      it 'returns the total calories group by date' do
        expected = [
          DayMeals.new(date.to_date , 800, yesterday), 
          DayMeals.new(date2.to_date, 600, another_day),
        ]
        expect(actual).to eq expected
      end
      
    end
    
  end
  
end
