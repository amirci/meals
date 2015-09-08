
class MealsApp.MealsIndexViewModel
  
  constructor: (meals) ->
    @days = (new DayMealsViewModel(m) for m in meals)
    @editor = new MealEditor()
    
  newMeal: -> @editor.active true
  
class MealEditor
  
  constructor: ->
    @active   = ko.observable false
    @date     = ko.observable moment()
    @calories = ko.observable 0
    @hours    = ko.observable 0
    @minutes  = ko.observable 0
    @meal     = ko.observable
    @saving   = ko.observable false
    @date_vm  = ko.pureComputed
      read: => @date().format('MMM D, YYYY')
      write: (value) => @date moment(value, 'MMM D, YYYY')
    
  cancel: -> @active false
  
  save: =>
    @saving true
    meal =
      date: @date().format('YYYY-MM-DD')
      time: "#{@hours()}:#{@minutes()}"
      calories: @calories()
      meal: @meal()

    options =
      success: => 
        new PNotify(title: 'Saving new meal', text: 'The meal was saved!', type: 'success')
        @active false
      error: -> 
        new PNotify(title: 'Saving new meal', text: 'Sorry an error occured', type: 'error')
      complete: => @saving false
      
    MealsApp.Meal.save meal, options
      
    
  
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