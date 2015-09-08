

class MealsApp.Meal
  
  @save: (meal, options={}) ->
    nop = ->

    $.ajax(
      url: Routes.new_meal_path(format: 'json')
      data: meal
      type: 'POST'
    ).success(options.done || nop).fail(options.error || nop).always(options.complete || nop)

