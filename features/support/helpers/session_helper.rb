module SessionHelper

  def parsed_sessions_json_response
    parsed = ActiveSupport::JSON.decode(last_json)
    parsed['sessions'] = parsed['sessions'].sort_by { |h| h['id'] }
    parsed['sessions'].each { |s| JsonHelper.new.update_json(s) }
    parsed
  end

  def parsed_session_json_response
    parsed = ActiveSupport::JSON.decode(last_json)
    JsonHelper.new.update_json(parsed['session'])
    parsed
  end
  
  def json_sessions_src
    { 'sessions' => JsonHelper.new.json_attr(active_conference.sessions) }
  end
  
  def json_session_src(id)
    { 'session' => JsonHelper.new.json_attr([] << Session.find(id)).first }
  end
  
  def filtered_sessions(filter)
    session_values active_conference.sessions.tagged_with(filter)
  end
  
  def session_filters
    active_conference.sessions.map { |s| s.tag_list }.flatten.uniq
  end
  
  def session_values(session)
    fn = ->(s) do
              {
                title: s.title,
                abstract: s.abstract,
                speakers: s.speakers.map { |sp| sp.name },
                tags: s.tag_list.map(&:upcase).sort
              }
            end
    values = ([] << session).flatten.map(&fn)
    session.respond_to?(:count) ? values : values.first
  end
  
  def attendance_report
    active_conference.sessions.map do |s|
      {
        title: s.title,
        speakers: s.speakers.map { |p| p.name }.join(','),
        attending: s.planning_to_attend
      }
    end
  end
  
  private
    class JsonHelper
      def update_json(s)
        s['start']  = Time.zone.parse(s['start'])  
        s['finish'] = Time.zone.parse(s['finish'])
        s['tags']   = s['tags'].map(&:upcase)
      end
      
      def as_json(sessions)
        target = sessions.respond_to?(:count) ? 
                    { sessions: json_attr(sessions) } :
                    { session: json_attr([] << sessions).first }
        target.to_json(except: exceptions)
      end
      
      def json_attr(sessions)
        sessions.sort_by(&:id).map do |s| 
          {
            id: s.id,
            title: s.title,
            abstract: s.abstract,
            speakers: s.speakers.map(&:id), 
            tags: s.tag_list.map(&:upcase).sort,
            start: s.event.nil? ? nil : s.event.start,
            finish: s.event.nil? ? nil : s.event.finish,
            room: s.event.nil? ? nil : s.event.room.name
          }.stringify_keys 
        end
      end
      
      def exceptions
        [ 'created_at', 'updated_at', 
          'event_id', 'upvotes', 'downvotes', 
          'planning_to_attend',
          'conference_id']
      end
    end
end

World(SessionHelper)