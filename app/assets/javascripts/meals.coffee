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
    
    @id       = ko.observable -1
    @date     = ko.observable moment()
    @calories = ko.observable()
    @hour     = ko.observable()
    @minutes  = ko.observable()
    @meal     = ko.observable()
    
    @isNewMeal = ko.observable false
    
    @cal_vm     = ko.pureComputed
      read: => @calories()
      write: (value) => @calories parseInt(value)
    @hours_vm   = ("#{h}".lpad(0, 2) for h in [0..23])
    @minutes_vm = ("#{m * 5}".lpad(0, 2) for m in [0..11])
    @date_vm    = ko.pureComputed
      read: => @date().format('MMM D, YYYY')
      write: (value) => @date moment(value, 'MMM D, YYYY')
  
  open: (saveMeal, current={}, newMeal=true) =>
    @saving false
    @saveMeal = saveMeal
    @load current
    @isNewMeal newMeal
    $(".new-meal-form").modal()    

  load: (meal={}) =>
    @id       meal.id
    @date     meal.moment?() || moment()
    @calories meal.calories?() || 0
    @hour     @date().format('HH')
    @minutes  @date().format('mm')
    @meal     meal.meal?() || ''

  cancel: -> 
    $(".new-meal-form").modal('hide')
  
  createMeal: =>
    date = @date().format('YYYY-MM-DD') + " #{@hour()}:#{@minutes()}"
    new MealsApp.Meal @id(), date, @meal(), @calories()

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
      
  
class UserConfiguration
  
  constructor: (@currentUser)->
    @calories = ko.observable @currentUser.calories
    @editing = ko.observable false
    @caloriesEdit = ko.observable @calories()
    @editFocus = ko.observable false
    
  edit: =>
    @caloriesEdit @calories()
    @editing true
    @editFocus true
    
  save: =>
    @calories parseInt(@caloriesEdit()) || 0
    @editing false
    MealsApp.UserConfig.update @currentUser.id, @calories()
    
  cancel: =>
    @editing false

class MealsApp.MealsIndexViewModel
  
  constructor: (meals, currentUser) ->
    @configEditor = new UserConfiguration(currentUser)
    @days = ko.observableArray(new DayMealsViewModel(@, m) for m in meals)
    @editor = MealEditor.create()
    
  newMeal: => 
    @editor.open(@save)
    
  save: (meal, options) =>
    options.success = [options.success, (data) => @insertMeal meal, data]
    MealsApp.Meal.save meal, options
    
  insertMeal: (meal, data) =>
    meal.id = data.id if data?.id
    key = meal.moment.format('YYYY-MM-DD')
    bigger = ([d, i] for d, i in @days() when d.date <= key)

    [found, index] = if bigger?.length then bigger[0] else [null, @days().length]

    unless found?.date == key
      found = new DayMealsViewModel(@, {date: meal.date, calories: 0, meals: []})
      @days.splice(index, 0, found)

    found.addMeal(meal)
    
class DayMealsViewModel
  
  constructor: (@parent, m) ->
    @moment = moment(m.date)
    @date   = @moment.format('YYYY-MM-DD')
    @day    = @moment.format('MMM D')
    @month  = @moment.format('YYYY')
    @total  = ko.observable m.calories
    @meals  = ko.observableArray(new MealsApp.MealViewModel(meal, @total) for meal in m.meals)

    @matchTotal = ko.pureComputed => 
      if @total() > @parent.configEditor.calories() then "red" else "green"
    
  addMeal: (m) ->
    key = m.moment.format('HH:mm')
    bigger = (i for d, i in @meals() when d.time() >= key)
    index = if bigger?.length then bigger[0] else @meals().length

    @meals.splice index, 0, new MealsApp.MealViewModel(m, @total)
    @total @total() + m.calories
    
  remove: (meal) =>
    if confirm("Are you sure you want to remove -- #{meal.meal()} -- ?")
      MealsApp.Meal.remove meal.id, 
        success: => @removeMeal meal
        error: -> new PNotify(title: 'Removing meal', text: 'Sorry an error occured', type: 'error')
        
  removeMeal: (meal) =>
    index = @meals.indexOf meal
    @total @total() - meal.calories()
    @meals.splice index, 1
    @parent.days.remove @ if @total() == 0

  hideMeal: (elem) =>
    if elem.nodeType == 1
      $(elem).find('div').fadeOut 1000, -> $(elem).closest('.meal-reg').remove()

class MealsApp.MealViewModel
  
  constructor: (m, @total) ->
    @id       = m.id
    @moment   = ko.observable moment(m.logged_at, 'YYYY-MM-DDTHH:mm:ss.SSSZZ')
    @calories = ko.observable m.calories
    @time     = ko.pureComputed => @moment().format('HH:mm')
    @meal     = ko.observable m.meal
    @editor   = MealEditor.create()
    @confirm  = ko.observable false
    
  edit: =>
    @editor.open(@update, @, false)
  
  update: (meal, options) =>
    options.success = [options.success, => @updateMeal meal]
    MealsApp.Meal.update meal, options
    
  updateMeal: (m) =>
    @total @total() + m.calories - @calories()
    @moment   m.moment
    @calories m.calories
    @meal     m.meal
    
    $("[data-id='#{@id}'] div").effect('highlight', {}, 5000)
    
    
