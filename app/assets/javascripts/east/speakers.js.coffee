# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

$ = jQuery
$ ->
  selectedClass = 'selected'
  cmdDetailHigh = $('#speakers p.display_options .cmd-high-detail')
  cmdDetailLow = $('#speakers p.display_options .cmd-low-detail')

  setDetail = (fromClass, toClass) ->
    return (ev) -> 
      $('#speakers').removeClass(fromClass).addClass(toClass)
                    .find('p.display_options .'+selectedClass).removeClass(selectedClass)
      $(this).addClass(selectedClass);
      return false

  cmdDetailHigh.click(setDetail('low-detail','high-detail'))
  cmdDetailLow.click(setDetail('high-detail','low-detail'))
