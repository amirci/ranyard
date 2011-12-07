class Conference < ActiveRecord::Base
  has_many :speakers
  has_many :sessions
  has_many :rooms
  has_many :events
  has_many :sponsors
  
  def days
    (start..finish).to_a
  end
  
  def events_for(day)
    return events.select { |e| e.start.to_date == day }.sort_by { |e| e.start } if day.kind_of? Date
    events_for(days[day - 1]) rescue []
  end
end
