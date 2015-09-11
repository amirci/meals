
class MealsApp.UserConfig
  
  constructor:  ->
    
  nop = ->
    
  @update: (id, calories, options={}) ->
    data =
      config:
        calories: calories
        
    $.ajax(
      url: Routes.api_v1_user_path(id)
      type: 'PUT'
      data: JSON.stringify(data)
      contentType: "application/json; charset=utf-8"
      dataType: "json"      
    ).success(options.success || nop).fail(options.error || nop).always(options.complete || nop)
