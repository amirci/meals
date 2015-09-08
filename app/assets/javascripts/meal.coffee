

class MealsApp.Meal
  
  constructor: (@date, @meal, @calories) ->
    @moment = moment(@date, [moment.ISO_8601, 'YYYY-MM-DD hh:mm:ss', 'YYYY-MM-DD hh:mm'])
    @logged_at = @date
    
  @save: (meal, options={}) ->
    nop = ->

    data =
      meal:
        logged_at: meal.date
        calories: parseInt(meal.calories)
        meal: meal.meal

    $.ajax(
      url: '/api/v1/meals.json'
      data: JSON.stringify(data)
      type: 'POST'
      contentType: "application/json; charset=utf-8"
      dataType: "json"      
    ).success(options.success || nop).fail(options.error || nop).always(options.complete || nop)

