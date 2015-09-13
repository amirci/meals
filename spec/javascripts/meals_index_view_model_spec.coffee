
describe 'MealsApp.MealViewModel', ->
  
  describe 'constructor', ->
    
    it 'creates all the values', ->
      meal = {meal: 'Chicken', calories:1000, logged_at: "2015-08-11T19:00:00.000-05:00"}
      vm = new MealsApp.MealViewModel meal, -> 0
    
      expect(vm.time()).toBe '19:00'
      
describe 'MealsApp.MealsIndexViewModel', ->

  user = {id:1, email: 'user@example.com', calores: 1200}
  
  describe '#insertMeal', ->
    
    describe 'When the date already exists', ->

      it 'appends the meal to the same date', ->
        days = [
          {date: '2015-07-22', calories: 2200, meals: [{meal: 'Chicken', calories:1000, logged_at: "2015-07-22 12:30"}]}
          {date: '2015-07-20', calories: 2200, meals: [{meal: 'Apple'  , calories:100 , logged_at: "2015-07-20 07:00"}]},
        ]
        
        vm = new MealsApp.MealsIndexViewModel days, user
        meal = new MealsApp.Meal(1, '2015-07-22 08:30', 'Steak', 1000)

        vm.insertMeal meal

        expect(vm.days().length).toBe(2)

        day = vm.days()[0]
        expect(day.day).toBe 'Jul 22'
        expect(day.total()).toBe 3200
        expect(day.meals().length).toBe 2
        expect(day.meals()[0].meal()).toBe 'Steak'

    describe 'When the date does not exist', ->

      it 'adds the day with the right order', ->
        days = [
          {date: '2015-07-22', calories: 2200, meals: [{meal: 'Chicken', calories:1000, logged_at: "2015-07-22 12:30"}]}
          {date: '2015-07-20', calories: 2200, meals: [{meal: 'Apple'  , calories:100 , logged_at: "2015-07-20 07:00"}]},
        ]
        
        vm = new MealsApp.MealsIndexViewModel days, user
        meal = new MealsApp.Meal(1, '2015-07-21 08:30', 'Steak', 1000)

        vm.insertMeal meal

        expect(vm.days().length).toBe(3)

        day = vm.days()[1]
        expect(day.day).toBe 'Jul 21'
        expect(day.month).toBe '2015'
        expect(day.meals().length).toBe 1
        expect(day.total()).toBe 1000
        
  describe '#constructor', ->
    it 'creates all the meals per day', ->
      meals = [
        {meal: 'Apple'  , calories:100 , logged_at: "2015-07-20 07:00"},
        {meal: 'Chicken', calories:1000, logged_at: "2015-07-20 12:30"},
        {meal: 'Tart'   , calories:1000, logged_at: "2015-07-20 15:30"},
        {meal: 'Noodles', calories:100 , logged_at: "2015-07-20 19:00"}
      ]
      days = [
        {date: '2015-07-20', calories: 2200, meals: meals}
      ]

      index = new MealsApp.MealsIndexViewModel days, user
    
      expect(index.days().length).toBe(1)

      dayVm = index.days()[0]
      expect(dayVm.day).toBe('Jul 20')
      expect(dayVm.month).toBe('2015')
      expect(dayVm.total()).toBe(2200)

      actual = dayVm.meals()
      expect(actual.length).toBe(4)
    
      compareMeal = (actualMeal, meal) ->
        expect(actualMeal.calories()).toBe meal.calories
        expect(actualMeal.meal()).toBe     meal.meal
        expect(actualMeal.time()).toBe     moment(meal.logged_at).format('HH:mm')
      
      (compareMeal actual[i], m for m, i in meals)
