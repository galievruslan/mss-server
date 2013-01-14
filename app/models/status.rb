class Status < ActiveRecord::Base
  attr_accessible :name
  has_many :route_points, :dependent => :destroy
  validates :name, :presence => true
end
