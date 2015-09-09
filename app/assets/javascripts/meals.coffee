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
    
class MealEditor
  
  instance = null
  
  @create: ->
    instance ?= new MealEditor()
    
  constructor: ->
    @saving   = ko.observable false

    @title    = ko.observable 'New Meal'
    @date     = ko.observable moment()
    @calories = ko.observable()
    @hour     = ko.observable()
    @minutes  = ko.observable()
    @meal     = ko.observable()
    
    @cal_vm     = ko.pureComputed
      read: => @calories()
      write: (value) => @calories parseInt(value)
    @hours_vm   = ("#{h}".lpad(0, 2) for h in [0..23])
    @minutes_vm = ("#{m * 5}".lpad(0, 2) for m in [0..11])
    @date_vm    = ko.pureComputed
      read: => @date().format('MMM D, YYYY')
      write: (value) => @date moment(value, 'MMM D, YYYY')
  
  load: (meal={}) =>
    @date     meal.moment || moment()
    @calories meal.calories || 0
    @hour     @date().format('HH')
    @minutes  @date().format('mm')
    @meal     meal.meal || ''
    
  open: (saveMeal, current={}) =>
    @saveMeal = saveMeal
    @load current
    $(".new-meal-form").modal()    

  cancel: -> 
    $(".new-meal-form").modal('hide')
  
  createMeal: =>
    date = @date().format('YYYY-MM-DD') + " #{@hour()}:#{@minutes()}"
    new MealsApp.Meal date, @meal(), @calories()

  save: =>
    @saving true
    
    meal = @createMeal()
    
    options =
      success: => 
        new PNotify(title: 'Saving new meal', text: 'The meal was saved!', type: 'success')
        @cancel()
        
      error: -> 
        new PNotify(title: 'Saving new meal', text: 'Sorry an error occured', type: 'error')

      complete: => @saving false
      
    @saveMeal meal, options
      
  
class MealsApp.MealsIndexViewModel
  
  constructor: (meals) ->
    @days = ko.observableArray(new DayMealsViewModel(m) for m in meals)
    @editor = MealEditor.create()
    
  newMeal: => 
    @editor.open(@save)
    
  save: (meal, options) =>
    success = options.success
    
    options.success = =>
      success()
      @insertMeal meal
      
    MealsApp.Meal.save meal, options
    
  insertMeal: (meal) =>
    key = meal.moment.format('YYYY-MM-DD')
    bigger = ([d, i] for d, i in @days() when d.date <= key)

    [found, index] = if bigger?.length then bigger[0] else [null, @days().length]

    unless found?.date == key
      found = new DayMealsViewModel(date: meal.date, calories: 0, meals: [])
      @days.splice(index, 0, found)

    found.addMeal(meal)
    
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
    @moment   = moment(m.logged_at)
    @calories = m.calories
    @time     = @moment.format('HH:mm')
    @meal     = m.meal
    @editor   = MealEditor.create()
    
  edit: =>
    @editor.open(@update, @)
  
  update: (meal, options) =>
    
  remove: => alert 'are you sure?'