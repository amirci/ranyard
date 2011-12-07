module ConferenceHelper 
  
  def create_schedule(*conferences)
    conferences.each do |c| 
      c.sessions.each_with_index do |s, i| 
        Fabricate(:event, 
                  start: c.days.sample + i.hours, 
                  session: s, 
                  conference: c, 
                  room: c.rooms.sample) 
      end
    end
  end
  
  def active_conference
    subdomain = Capybara.default_host.sub("http://", "").split('.')[0]
    subdomain = nil if subdomain == "www"
    Conference.where(active: true, subdomain: subdomain).first
  end
  
  def conference_details(conf)
    { city: conf.city, venue: conf.venue, dates: conference_days(conf) }
  end
  
  def conference_days(conf)
    head = conf.days[0..-2].map { |d| d.day }.join(', ')
    month = conf.days.first.strftime("%B")
    year = conf.days.first.year
    "#{month} #{head} & #{conf.days.last.day}, #{year}"
  end
  
  def map_attributes(conf)
    return conf.map { |c| filter(c.attributes) } if conf.kind_of? Array
    filter(conf.attributes)
  end
  
  private
    def filter(attrib)
      exceptions = ['updated_at', 'created_at', 'id']
      attrib.
        delete_if { |k, v| exceptions.include? k }.
        inject({}){ |map, (k,v)| map[k.to_sym] = v; map}
    end
end

World(ConferenceHelper)
