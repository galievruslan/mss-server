class Status < ActiveRecord::Base
  attr_accessible :name
  has_many :route_points
end
