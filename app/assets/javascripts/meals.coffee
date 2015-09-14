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


class MealsFilter
  constructor: (@meals)->
    @dateFrom = ko.observable moment()
    @dateTo   = ko.observable moment()
    @timeFrom = ko.observable moment()
    @timeTo   = ko.observable moment()
    @active   = ko.observable false
    @inactive = ko.pureComputed => ! @active()

    $('#filter .date-from, #filter .date-to').datetimepicker
      ignoreReadonly: true
      format: 'MMM DD, YYYY'
      showClear: true

    $("#filter .time-from, #filter .time-to").datetimepicker 
      ignoreReadonly: true
      showClear: true
      format: 'LT'

    $("#filter .date-from").on 'dp.change', (ev) => @dateFrom ev.date?.format?('L')
    $("#filter .date-to"  ).on 'dp.change', (ev) => @dateTo   ev.date?.format?('L')
    $("#filter .time-from").on 'dp.change', (ev) => @timeFrom ev.date?.format?('HH:mm')
    $("#filter .time-to"  ).on 'dp.change', (ev) => @timeTo   ev.date?.format?('HH:mm')

  filter: (day) =>
    (!@dateFrom() || day.moment.format('L') >= @dateFrom()) &&
    (!@dateTo()   || day.moment.format('L') <= @dateTo()  )
    
  filterMeal: (m) =>
    console.log ">>>> Checking time for #{@timeFrom()} and #{@timeTo()}"
    (!@timeFrom() || m.time() >= @timeFrom()) &&
    (!@timeTo()   || m.time() <= @timeTo())
    
  apply: =>
    @active true

  cancel: =>
    @active false
    
class MealsApp.MealsIndexViewModel
  
  constructor: (meals, currentUser) ->
    @configEditor = new UserConfiguration(currentUser)
    @days = ko.observableArray @createMeals(meals)
    @filter = new MealsFilter @
    @filtered = ko.computed => (d for d in @days() when @filter.inactive() || @filter.filter d)
    @editor = MealEditor.create()
    
    @emptyMeals  = ko.pureComputed => @filtered().length == 0 && @filter.inactive()
    
    @emptyFilter = ko.pureComputed => @filtered().length == 0 && @filter.active()
    
  createMeals: (meals) =>
    hash = {}
    for m in meals
      meal = new MealsApp.Meal m.id, m.logged_at, m.meal, m.calories
      hash[meal.day] = new DayMealsViewModel(@, meal.moment) unless hash[meal.day]?
      hash[meal.day].addMeal meal
    (v for k, v of hash).sort (a, b) -> b.date.localeCompare a.date
    
  newMeal: => 
    @editor.open(@save)
    
  save: (meal, options) =>
    options.success = [options.success, (data) => @insertMeal meal, data]
    MealsApp.Meal.save meal, options
    
  insertMeal: (meal, data) =>
    meal.id = data.id if data?.id
    bigger = ([d, i] for d, i in @days() when d.date <= meal.day)

    [found, index] = if bigger?.length then bigger[0] else [null, @days().length]

    unless found?.date == meal.day
      found = new DayMealsViewModel(@, meal.moment)
      @days.splice(index, 0, found)

    found.addMeal(meal)
    
class DayMealsViewModel
  
  constructor: (@parent, @moment) ->
    @date   = @moment.format('YYYY-MM-DD')
    @day    = @moment.format('MMM D')
    @month  = @moment.format('YYYY')
    @meals  = ko.observableArray []
    
    @filtered = ko.pureComputed =>
      (m for m in @meals() when @parent.filter.inactive() || @parent.filter.filterMeal m)
      
    @total  = ko.pureComputed =>
      calories = (m.calories() for m in @filtered())
      if calories.length then calories.reduce (m1, m2) -> m1 + m2 else 0

    @matchTotal = ko.pureComputed => 
      if @total() > @parent.configEditor.calories() then "red" else "green"
    
  addMeal: (m) ->
    bigger = (i for d, i in @meals() when d.time() >= m.time)
    index = if bigger?.length then bigger[0] else @meals().length

    @meals.splice index, 0, new MealsApp.MealViewModel(m, @total)
    
  remove: (meal) =>
    if confirm("Are you sure you want to remove -- #{meal.meal()} -- ?")
      MealsApp.Meal.remove meal.id, 
        success: => @removeMeal meal
        error: -> new PNotify(title: 'Removing meal', text: 'Sorry an error occured', type: 'error')
        
  removeMeal: (meal) =>
    index = @meals.indexOf meal
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
    
    
