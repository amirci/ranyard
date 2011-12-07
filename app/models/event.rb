class Event < ActiveRecord::Base
  has_one :session
  belongs_to :room
  belongs_to :conference
  
  def slot
    TimeSlot.new(start: self.start, finish: self.finish)
  end
end
