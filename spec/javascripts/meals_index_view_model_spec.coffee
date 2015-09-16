
describe 'MealsApp.MealViewModel', ->
  
  describe 'constructor', ->
    
    it 'creates all the values', ->
      meal = {meal: 'Chicken', calories:1000, logged_at: "2015-08-11T19:00:00.000Z"}
      vm = new MealsApp.MealViewModel meal, -> 0
    
      expect(vm.time()).toBe moment(meal.logged_at, 'YYYY-MM-DDTHH:mm:ss.SSSZZ').format('HH:mm')
      
describe 'MealsApp.MealsIndexViewModel', ->

  user = {id:1, email: 'user@example.com', calores: 1200}
  
  meals = [
    {id: 1, meal: 'Apple'  , calories: 100 , logged_at: "2015-07-20T13:30:00.000Z"},
    {id: 2, meal: 'Chicken', calories: 1000, logged_at: "2015-07-20T15:00:00.000Z"},
    {id: 3, meal: 'Tart'   , calories: 1000, logged_at: "2015-07-20T17:30:00.000Z"},

    {id: 4, meal: 'Noodles', calories: 100 , logged_at: "2015-07-21T15:00:00.000Z"}
    {id: 5, meal: 'Apple'  , calories: 100 , logged_at: "2015-07-21T13:30:00.000Z"},

    {id: 6, meal: 'Chicken', calories: 1000, logged_at: "2015-07-22T13:30:00.000Z"},
    {id: 7, meal: 'Potatoe', calories: 1000, logged_at: "2015-07-22T15:00:00.000Z"},
  ]

  describe '#constructor', ->
    it 'creates all the meals per day', ->
      index = new MealsApp.MealsIndexViewModel meals, user

      expect(index.days().length).toBe(3)

      dayVm = index.days()[0]
      expect(dayVm.day).toBe('Jul 22')
      expect(dayVm.month).toBe('2015')
      expect(dayVm.total()).toBe(2000)

      actual = dayVm.meals()

      compareMeal = (actual, meal) ->
        expect(actual.calories()).toBe meal.calories
        expect(actual.meal()).toBe meal.meal
        expect(actual.time()).toBe moment(meal.logged_at).format('HH:mm')

      (compareMeal actual[i], m for m, i in meals[5..-1])

  describe '#insertMeal', ->

    describe 'When the date already exists', ->

      it 'appends the meal to the same date', ->
        vm = new MealsApp.MealsIndexViewModel meals, user
        meal = new MealsApp.Meal(1, '2015-07-22T12:30:00.000Z', 'Steak', 1000)

        vm.insertMeal meal

        expect(vm.days().length).toBe(3)

        day = vm.days()[0]
        expect(day.day).toBe 'Jul 22'
        expect(day.total()).toBe 3000
        expect(day.meals().length).toBe 3
        expect(day.meals()[0].meal()).toBe 'Steak'

    describe 'When the date does not exist', ->

      it 'adds the day with the right order', ->
        vm = new MealsApp.MealsIndexViewModel meals, user
        meal = new MealsApp.Meal(1, '2015-07-23T13:30.00.000Z', 'Steak', 1000)

        vm.insertMeal meal

        expect(vm.days().length).toBe(4)

        day = vm.days()[0]
        expect(day.day).toBe 'Jul 23'
        expect(day.month).toBe '2015'
        expect(day.meals().length).toBe 1
        expect(day.total()).toBe 1000

