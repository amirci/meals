

class MealsApp.Meal
  
  @save: (meal, options={}) ->
    nop = ->

    $.ajax(
      url: '/api/v1/meals.json'
      data: meal
      type: 'POST'
    ).success(options.done || nop).fail(options.error || nop).always(options.complete || nop)

