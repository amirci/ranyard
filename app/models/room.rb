class Room < ActiveRecord::Base
  has_many :events
  belongs_to :conference  
end
