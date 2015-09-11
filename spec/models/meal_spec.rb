require 'rails_helper'

RSpec.describe Meal, type: :model do
  
  context 'Validations' do
    describe 'Meal is required' do
      it { should validate_presence_of(:meal) }
    end
    
    describe 'Calories is required' do
      it { should validate_presence_of(:calories) }
    end
    
    describe 'Logged at is required' do
      it { should validate_presence_of(:logged_at) }
    end
    
    describe 'Calories has to be a number greater than zero' do
      it { should validate_numericality_of(:calories).only_integer.is_greater_than(0) }
    end
  end
  
  context 'Scopes' do
    
    describe '.for_user' do
      let(:user) { create :user }
      let(:other_user) { create :user }
      
      before do
        create_list :meal, 10, user: user
        create_list :meal, 10, user: other_user
      end
      
      it 'returns the meals for the specified user' do
        expect(Meal.for_user user).to eq Meal.where(user: user)
      end
    end
    
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
