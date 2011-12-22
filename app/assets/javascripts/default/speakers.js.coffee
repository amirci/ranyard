# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.

$ = jQuery
$ ->
  selectedClass = 'selected'
  cmdDetailHigh = $('#speakers .cmd-high-detail')
  cmdDetailLow = $('#speakers .cmd-low-detail')

  setDetail = (fromClass, toClass) ->
    return (ev) -> 
      $('#speakers').removeClass(fromClass).addClass(toClass)
                    .find('.page-detail .' + selectedClass).removeClass(selectedClass)
      $(this).addClass(selectedClass);
      return false

  cmdDetailHigh.click(setDetail('low-detail','high-detail'))
  cmdDetailLow.click(setDetail('high-detail','low-detail'))
