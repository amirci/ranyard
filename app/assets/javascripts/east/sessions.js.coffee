# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#
#
#
$ = jQuery
$ ->
  clear_filter_trigger = $('#tag-list li.cmd-clear-filter')
  all_tags = $('#tag-list li').not('.cmd-clear-filter')
  enabled_class = 'on'
  session_item_selector = '#session-list > li'
  all_items = $(session_item_selector)

  tag_clicked = (ev) ->
    $target = $(ev.target)
    mark_enabled($target)
    selected_tag = get_selected_tag($target)
    apply_filter(selected_tag)
    return false

  clear_filter_trigger_clicked = (ev) ->
    clear_the_filter()
    return false

  all_tags.click(tag_clicked)
  clear_filter_trigger.click(clear_filter_trigger_clicked)

  mark_enabled = (t) =>
    mark_disabled(all_tags.add(clear_filter_trigger))
    t.addClass(enabled_class)

  mark_disabled = (t) =>
    t.removeClass(enabled_class)

  apply_filter = (selected_tag) ->
    found = all_items.find(".tags:contains('#{selected_tag}')")
    items_to_show = found.parents(session_item_selector)
    items_to_hide = all_items.not(items_to_show)

    items_to_show.show().animateHighlight(null, 1000)
    items_to_hide.hide()

    return false

  get_selected_tag = (t) =>
    selected_tag = t.text()
    selected_tag = selected_tag.toUpperCase()
    return selected_tag

  clear_the_filter = ->
    mark_disabled(all_tags)
    mark_enabled(clear_filter_trigger)
    all_tags.removeClass(enabled_class)
    all_items.show()

  clear_the_filter()

$ ->
  selectedClass = 'selected'
  cmdDetailHigh = $('#sessions p.display_options .cmd-high-detail')
  cmdDetailLow = $('#sessions p.display_options .cmd-low-detail')

  setDetail = (fromClass, toClass) ->
    return (ev) -> 
      $('#session-list').removeClass(fromClass).addClass(toClass)
                    .parent()
                    .find('p.display_options .'+selectedClass).removeClass(selectedClass)
      $(this).addClass(selectedClass);
      return false

  cmdDetailHigh.click(setDetail('low-detail','high-detail'))
  cmdDetailLow.click(setDetail('high-detail','low-detail'))

$ -> 
  split_char = '_'
  sessionItems = $('#session-list > li');
  $('#session-list').addClass('planning_to_attend');

  attendingForms = sessionItems.find('.planning_to_attend form');
  notAttendingForms = sessionItems.find('.attending form');
  
  attendingCookie = $.cookie('attending') || ''
  sessions_attending = if attendingCookie == '' then [] else attendingCookie.split(split_char) 
  
  get_selector_for_session = (i) =>

  mark_attending = (n) =>
    $('#session_'+n).addClass('attending')

  mark_not_attending = (n) =>
    $('#session_'+n).removeClass('attending')

  update_cookie = ->
    $.cookie('attending', sessions_attending.join(split_char))
    
  attending_submitting = (ev) =>
    btn = $(ev.target).find("input[type='submit']").attr('disabled', 'disabled')
    form = $(ev.target).closest('form')
    action = form.attr('action')
    $.post(action, form.serialize(), attending_submitted, 'json')
    form.closest('li').find("input[type='submit']").not(btn).removeAttr('disabled');
    return false

  attending_submitted = (data) =>
    mark_attending(data.id)
    sessions_attending.push(data.id)
    update_cookie()

  not_attending_submitting = (ev) =>
    btn = $(ev.target).find("input[type='submit']").attr('disabled', 'disabled')
    form = btn.closest('form')
    action = form.attr('action')
    $.post(action, form.serialize(), not_attending_submitted, 'json')
    form.closest('li').find("input[type='submit']").not(btn).removeAttr('disabled');
    return false
    
  not_attending_submitted = (data) =>
    mark_not_attending(data.id)
    sessions_attending.delete(data.id)
    update_cookie()

  $.each(sessions_attending, (i,n) -> mark_attending(n))
  attendingForms.submit(attending_submitting)
  notAttendingForms.submit(not_attending_submitting)

