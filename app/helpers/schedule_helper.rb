module ScheduleHelper

  def event_title(event)
    return "-" if event.nil?
    s = event.session
    return event.custom if s.nil?
    link_to(s.title, event.session) + 
    link_to("", "*", name: "session_#{s.id}") + 
    (current_user ? content_tag(:div, "(#{s.planning_to_attend})", class: 'attending') : "")
  end

  def format_slot(slot)
    slot.start.strftime('%I:%M') +
    ' to ' +
    slot.finish.strftime('%I:%M')
  end

  def schedule_headers(rooms)
    content_tag(:tr, nil) do
      content_tag(:th, 'Time') +
      rooms.collect { |room| content_tag(:th, room.name, class: 'room') }.reduce(:+)
    end
  end

  def schedule_events(events, rooms)
    event_slots(events).map do |slot|
      content_tag(:tr, nil) do
        content_tag(:td, format_slot(slot), class: 'slot') + 
        event_cells(events_for_slot(events, slot), rooms)
      end
    end.reduce(:+)
  end
  
  def events_for_slot(events, slot)
    events.select { |e| e.start ==  slot.start }
  end
  
  def event_slots(events)
    events.map { |e| TimeSlot.new(start: e.start, finish: e.finish) }.uniq.sort
  end
  
  def event_cells(events, rooms)
    return if events.empty?
    return content_tag(:td, 
                       event_title(events.first), 
                       class: "main_event", 
                       colspan: rooms.count) if events.first.main
    
    rooms.map do |room|
      e = events.select { |e| e.room == room }.first
      content_tag(:td, event_title(e), class: 'event')
    end.reduce(:+)
  end
end
