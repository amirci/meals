
describe 'MealsApp.MealsIndexViewModel', ->
  
  it 'creates all the meals per day', ->
    meals = [
      {meal: 'Apple'  , calories:100 , logged_at: "2015-07-20 07:00:00"},
      {meal: 'Chicken', calories:1000, logged_at: "2015-07-20 12:30:00"},
      {meal: 'Tart'   , calories:1000, logged_at: "2015-07-20 15:30:00"},
      {meal: 'Noodles', calories:100 , logged_at: "2015-07-20 19:00:00"}
    ]
    days = [
      {date: '2015-07-20', calories: 2200, meals: meals}
    ]

    index = new MealsApp.MealsIndexViewModel days
    
    expect(index.days.length).toBe(1)

    dayVm = index.days[0]
    expect(dayVm.day).toBe('Jul 20')
    expect(dayVm.month).toBe('2015')
    expect(dayVm.total).toBe(2200)

    actual = dayVm.meals
    expect(actual.length).toBe(4)
    
    compareMeal = (actualMeal, meal) ->
      expect(actualMeal.calories).toBe meal.calories
      expect(actualMeal.meal).toBe     meal.meal
      expect(actualMeal.time).toBe     moment(meal.logged_at).format('HH:mm')
      
    (compareMeal actual[i], m for m, i in meals)
