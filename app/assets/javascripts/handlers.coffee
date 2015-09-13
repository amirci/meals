ko.bindingHandlers.slideVisible =
  init: (element, valueAccessor) ->
    value = valueAccessor()
    $(element).toggle(ko.unwrap(value))

  update: (element, valueAccessor) ->
    value = valueAccessor()
    if ko.unwrap(value) then $(element).slideDown() else $(element).slideUp()


