
class MealsApp.MealsIndexViewModel
  
  constructor: (meals) ->
    @days = (new DayMealsViewModel(m) for m in meals)
    
    
class DayMealsViewModel
  
  constructor: (m) ->
    @moment = moment(m.date)
    @day    = @moment.format('MMM D')
    @month  = @moment.format('YYYY')
    @total  = m.calories
    @meals  = (new MealViewModel(meal) for meal in m.meals)

    
class MealViewModel
  
  constructor: (m) ->
    @calories = m.calories
    @time     = moment(m.logged_at).format('HH:mm')
    @meal     = m.meal