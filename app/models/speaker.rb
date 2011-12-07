class Speaker < ActiveRecord::Base
  has_many :assignments
  has_many :sessions, :through => :assignments, :dependent => :destroy, :uniq => true
  belongs_to :conference
end
