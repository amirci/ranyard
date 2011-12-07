class User < ActiveRecord::Base
  has_secure_password  
  attr_accessible :email, :password
  validates_presence_of :password, :on => :create
  validates_presence_of :email
end
