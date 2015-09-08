if (typeof String::lpad != 'function')
  String::lpad = (padString, length) ->
    str = this
    while str.length < length
      str = padString + str
    return str
 
if (typeof String::rpad != 'function')
  String::rpad = (padString, length) ->
    str = this
    while str.length < length
      str = str + padString
    return str
    
class MealsApp.MealsIndexViewModel
  
  constructor: (meals) ->
    @days = ko.observableArray(new DayMealsViewModel(m) for m in meals)
    @editor = new MealEditor(@insertMeal)
    
  newMeal: -> @editor.active true
  
  insertMeal: (meal) =>
    key = meal.moment.format('YYYY-MM-DD')
    bigger = ([d, i] for d, i in @days() when d.date <= key)

    [found, index] = if bigger?.length then bigger[0] else [null, @days().length]

    unless found?.date == key
      found = new DayMealsViewModel(date: meal.date, calories: 0, meals: [])
      @days.splice(index, 0, found)

    found.addMeal(meal)
    
class MealEditor
  
  constructor: (@insertMeal) ->
    @active   = ko.observable false
    @date     = ko.observable moment()
    @calories = ko.observable 0
    @hour     = ko.observable 0
    @minutes  = ko.observable 0
    @meal     = ko.observable ''
    @saving   = ko.observable false
    
    @hours_vm = ("#{h}".lpad(0, 2) for h in [0..23])
    @minutes_vm = ("#{m * 5}".lpad(0, 2) for m in [0..11])
    @date_vm  = ko.pureComputed
      read: => @date().format('MMM D, YYYY')
      write: (value) => @date moment(value, 'MMM D, YYYY')
    
  cancel: -> @active false
  
  createMeal: =>
    date = @date().format('YYYY-MM-DD') + " #{@hour()}:#{@minutes()}"
    new MealsApp.Meal date, @meal(), @calories()

  save: =>
    @saving true
    
    meal = @createMeal()
    
    options =
      success: => 
        new PNotify(title: 'Saving new meal', text: 'The meal was saved!', type: 'success')
        @insertMeal meal
        @active false
      error: -> 
        new PNotify(title: 'Saving new meal', text: 'Sorry an error occured', type: 'error')
      complete: => @saving false
      
    MealsApp.Meal.save meal, options
      
    
  
class DayMealsViewModel
  
  constructor: (m) ->
    @moment = moment(m.date)
    @date   = @moment.format('YYYY-MM-DD')
    @day    = @moment.format('MMM D')
    @month  = @moment.format('YYYY')
    @total  = m.calories
    @meals  = ko.observableArray(new MealViewModel(meal) for meal in m.meals)

  addMeal: (m) ->
    key = m.moment.format('HH:mm')
    bigger = (i for d, i in @meals() when d.time >= key)
    index = if bigger?.length then bigger[0] else @meals().length

    @meals.splice index, 0, new MealViewModel(m)
    @total += m.calories
    
class MealViewModel
  
  constructor: (m) ->
    @calories = m.calories
    @time     = moment(m.logged_at).format('HH:mm')
    @meal     = m.meal