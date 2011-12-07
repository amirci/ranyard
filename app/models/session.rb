class Session < ActiveRecord::Base
  has_many :assignments
  has_many :speakers, :through => :assignments, :uniq => true
  belongs_to :event
  belongs_to :conference
  
  validates_presence_of :title, :abstract
  acts_as_taggable

  def planning_to_attend
    self[:planning_to_attend] || 0
  end

end
