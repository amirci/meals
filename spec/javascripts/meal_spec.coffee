

describe 'Meal', ->
  
  describe '#constructor', ->
    
    it 'uses format ISO for the date', ->
      
      meal = new MealsApp.Meal(1, '2015-07-21 16:00', 'Chicken', 1000)
      expected = moment('2015-07-21T16:00:00.00')
      expect(meal.moment.isSame(expected)).toBe true
      
      
