

class MealsApp.Meal
  
  nop = ->
    
  constructor: (@id, @date, @meal, @calories) ->
    @moment = moment(@date, [moment.ISO_8601, 'YYYY-MM-DD hh:mm:ss', 'YYYY-MM-DD hh:mm'])
    @logged_at = @date
    
  @jsonData: (meal) ->
    data =
      meal:
        logged_at: meal.date
        calories: parseInt(meal.calories)
        meal: meal.meal
    
    JSON.stringify(data)

  @apiCall: (meal, route, type, options={}) ->
    $.ajax(
      url: route
      data: Meal.jsonData(meal)
      type: type
      contentType: "application/json; charset=utf-8"
      dataType: "json"      
    ).success(options.success || nop).fail(options.error || nop).always(options.complete || nop)
    
  @update: (meal, options={}) ->
    Meal.apiCall meal, Routes.api_v1_meal_path(meal.id), 'PUT', options
      
  @save: (meal, options={}) ->
    Meal.apiCall meal, Routes.api_v1_meals_path(), 'POST', options

