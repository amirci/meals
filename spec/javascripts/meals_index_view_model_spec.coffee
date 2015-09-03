
describe 'MealsApp.MealsIndexViewModel', ->
  
  it 'creates all the meals per day', ->
    meals = [
      {meal: 'Chicken', calories:1000, logged_at: "2015-07-08T12:30:00.000Z"},
      {meal: 'Apple'  , calories:100 , logged_at: "2015-07-08T07:00:00.000Z"},
      {meal: 'Chicken', calories:1000, logged_at: "2015-08-08T12:30:00.000Z"},
      {meal: 'Apple'  , calories:100 , logged_at: "2015-08-08T07:00:00.000Z"}
    ]
    index = new MealsApp.MealsIndexViewModel meals
    
    expect(1).toBe(4)                                                                                                             
