

class MealsApp.Meal
  
  constructor: (@id, @date, @meal, @calories) ->
    @moment = moment(@date, [
      moment.ISO_8601,
      'YYYY-MM-DDTHH:mm:ss.SSSZZ',
      'YYYY-MM-DD hh:mm:ss', 
      'YYYY-MM-DD hh:mm'
    ])
    @logged_at = @date
    
  @update: (meal, options={}) ->
    Meal.apiCall meal, Routes.api_v1_meal_path(meal.id), 'PUT', options
      
  @save: (meal, options={}) ->
    Meal.apiCall meal, Routes.api_v1_meals_path(), 'POST', options

  @remove: (id, options={}) ->
    $.ajax(
      url: Routes.api_v1_meal_path(id)
      type: 'DELETE'
      contentType: "application/json; charset=utf-8"
      dataType: "json"      
    ).success(options.success || nop).fail(options.error || nop).always(options.complete || nop)
    
  @jsonData: (meal) ->
    data =
      meal:
        logged_at: meal.moment.format('YYYY-MM-DDTHH:mm:ss.SSSZZ')
        calories: parseInt(meal.calories)
        meal: meal.meal.trim()
    
    JSON.stringify(data)

  nop = ->
    
  @apiCall: (meal, route, type, options={}) ->
    $.ajax(
      url: route
      data: Meal.jsonData(meal)
      type: type
      contentType: "application/json; charset=utf-8"
      dataType: "json"      
    ).success(options.success || nop).fail(options.error || nop).always(options.complete || nop)
    

