

describe 'Meal', ->
  
  describe '#constructor', ->
    
    it 'uses format ISO for the date', ->
      
      meal = new MealsApp.Meal(1, '2015-07-21 08:00', 'Chicken', 1000)
      
      expect(meal.moment.format('YYYY-MM-DD hh:mm')).toBe '2015-07-21 08:00'