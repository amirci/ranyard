class ConferenceStatus
  
  def self.last_update
    [Sponsor, Session, Event, Speaker, Room].
      map { |m| m.order(:updated_at).last }.
      delete_if { |r| r.nil? }.
      map { |r| r.updated_at }.
      max
  end  
  
end