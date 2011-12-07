module ScheduleHelper

  def parsed_schedule_json_response
    result = ActiveSupport::JSON.decode(last_json)
    result['schedule'].each_pair do |day, events|
      events.each do |e| 
        e['start'] = Time.zone.parse(e['start'])  
        e['finish'] = Time.zone.parse(e['finish'])
      end
    end
    result
  end
  
  def parse_event(attrib, day)
    start = Conference.where(active:true).first.start.to_datetime.beginning_of_day.utc
    day -= 1

    title = attrib.delete('session')
    s = Session.find_by_title(title)
    attrib[:session_id] = s.nil? ? nil : s.id
    attrib[:main] = attrib[:main] == "true"
    attrib[:custom] = attrib['custom'].empty? ? nil : attrib['custom']

    d = DateTime.parse(attrib[:start])
    attrib[:start] = (start + day).change(hour: d.hour).change(min: d.min).strftime('%Y-%m-%dT%H:%M:00Z')

    d = DateTime.parse(attrib[:finish])
    attrib[:finish] = (start + day).change(hour: d.hour).change(min: d.min).strftime('%Y-%m-%dT%H:%M:00Z')
    attrib
  end

  def calendar_from_table(table)
    headers = table.headers
    headers.delete('main')

    rows = table.hashes.map do |attrib|
      attrib.delete('main') == 'true' ? attrib.values.shift(2) : attrib.values
    end

    { header: headers, rows: rows }
  end

  def events_for_day(day)
    active_conference.events_for(day).map(&json_event)
  end

  def conference_schedule
    active_conference.days.map(&create_calendar).reject(&empty_calendar)
  end
  
  def json_schedule_src
    i = 0
    days = active_conference.days.inject({}) do |hash, d| 
      i += 1
      hash["day_#{i}"] = json_day_src(d)[:day]
      hash
    end
    { 'schedule' => days }
  end
  
  def json_day_src(day)
    { day: events_for_day(day) }
  end
  
  private    
    def create_calendar
      ->(day) { {header: calendar_headers(day), rows: calendar_rows(day)} }
    end

    def empty_calendar
      ->(cal) { cal[:rows].empty? || cal[:rows].map { |r| r.drop(1).all? { |c| c.nil? } }.reduce(:&) }
    end
    
    def calendar_headers(day)
      active_conference.rooms.inject(['Time']) { |header, r| header << r.name ; header }
    end
    
    def calendar_rows(day)
      events = active_conference.events_for(day)
      schedule = time_slots(events).map do |slot|
        slot_events = events.select { |e| e.start == slot.start }
        row = [format_slot(slot)] +
              active_conference.rooms.map {|r| format_event(slot_events.select { |e| e.room == r }.first)}
        row = row.reject { |c| c == '-'} if slot_events.any? { |e| e.main }
        row
      end
    end
    
    def format_slot(slot)
      "#{slot.start.strftime('%I:%M')} - #{slot.finish.strftime('%I:%M')}"
    end
    
    def time_slots(events)
      events.map { |e| TimeSlot.new(start: e.start, finish: e.finish) }.uniq.sort
    end
    
    def format_event(event)
      return "-" unless event
      return event.custom || "-" if event.session.nil?
      event.session.title
    end
    
    def json_event
      ->(e) do
        {
          id: e.id,
          start: e.start,
          finish: e.finish,
          custom: e.custom,
          main: e.main,
          session_id: e.session ? e.session.id : nil,
          room: e.room ? e.room.name : nil
        }.stringify_keys
      end
    end

end

World(ScheduleHelper)
