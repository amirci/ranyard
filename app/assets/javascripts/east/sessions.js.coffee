# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/
#

$ = jQuery
$ ->
  clear_filter_trigger = $('#tag-list li.cmd-clear-filter')
  all_tags = $('#tag-list li').not('.cmd-clear-filter')
  enabled_class = 'on'
  session_item_selector = '.session'
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
  cmdDetailHigh = $('#sessions .cmd-high-detail')
  cmdDetailLow = $('#sessions .cmd-low-detail')

  setDetail = (fromClass, toClass) ->
    return (ev) -> 
      $('#sessions').removeClass(fromClass).addClass(toClass)
                    .find('.page-detail .' + selectedClass).removeClass(selectedClass)
      $(this).addClass(selectedClass);
      return false

  cmdDetailHigh.click(setDetail('low-detail','high-detail'))
  cmdDetailLow.click(setDetail('high-detail','low-detail'))


$ -> 
  split_char = '_'
  sessionItems = $('.session');
  attendingForms = sessionItems.find('.star form');
  
  attendingCookie = $.cookie('attending') || ''
  sessions_attending = if attendingCookie == '' then [] else attendingCookie.split(split_char) 
  
  get_selector_for_session = (i) =>

  mark_attending = (n) =>
    update_attending_form_action(n, false)
    $("#session_#{n} .star .btn").addClass('starred').val('Favourite')

  mark_not_attending = (n) =>
    update_attending_form_action(n, true)
    $("#session_#{n} .star .btn").removeClass('starred').val('Star It!')

  update_attending_form_action = (n, should_attend) =>
    form = $("#session_#{n} .star form")
    href = form.attr('action').split('/')
    href.pop()
    href.push(if should_attend then 'attending' else 'not_attending')
    form.attr('action', href.join('/'))

  update_cookie = ->
    $.cookie('attending', sessions_attending.join(split_char))
    
  update_favourite_status = (ev) =>
    make_regular = $(ev.target).find(".btn").hasClass('starred')
    form = $(ev.target).closest('form')
    submit_fn = if make_regular then not_attending_submitted else attending_submitted
    $.post(form.attr('action'), form.serialize(), submit_fn, 'json')
    return false

  attending_submitted = (data) =>
    mark_attending(data.id)
    sessions_attending.push(data.id)
    update_cookie()

  not_attending_submitted = (data) =>
    mark_not_attending(data.id)
    index = sessions_attending.indexOf(data.id.toString())
    sessions_attending.splice(index, 1)
    update_cookie()

  # Using the favourite sessions, update the markup to reflect the status
  $.each(sessions_attending, (i,n) -> mark_attending(n))

  # When the form submits, update favourite status for the session
  attendingForms.submit(update_favourite_status)

