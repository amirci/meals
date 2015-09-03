
class MealsApp.MealsIndexViewModel
  
  constructor: (meals) ->
    days = {}
    (@insertDay(days, m) for m in meals)
    @days = (v for k, v of days).sort (d1, d2) ->
    
  insertDay: (days, m) ->
    days[m.logged_at] = new DailyMealsViewModel(m) unless days[m.logged_at]
    days[m.logged_at].addMeal m
    
class DailyMealsViewModel
  
  constructor: (m) ->
    @loggedAt = m.logged_at
    @moment = moment(m.logged_at)
    @day    = @moment.format('MMM D')
    @month  = @moment.format('YYYY')
    @total  = 0
    @meals  = []

  addMeal: (m) ->
    @total += m.calories
    @meals.push new MealViewModel(m)
    
class MealViewModel
  
  constructor: (m) ->
    @calories = m.calories
    @time     = moment(m.logged_at).format('HH:MM')
    @meal     = m.meal