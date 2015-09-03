require 'rails_helper'

feature "Lists all the meals for the current user" do
  
  context 'When some meals exists in the database for the current user' do
    before :each do
      create_list :meals, 10
    end

    it "lists all the meals" do
      visit '/meals'
      
      actual = all('.meal').map do |node| 
        {
          logged_at: node.find('.date').text + node.find('.time').text,
          meal: node.find('.meal').text,
          calories: node.find('.calories').text
        }
      end
      
      expected = Post.all.map do |p|
        {
          logged_at: p.date,
          meal: p.meal,
          calories: p.calories
        }
      end
      
      expect(actual).to eq expected
    end
  end
  
  context 'When no meals are available' do
    it 'shows an empty list message' do
      visit '/meals'
      
      actual = all('.meal')
      
      expect(actual).to be_empty
    end
  end
  
end