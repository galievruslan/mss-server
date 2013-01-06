class Route < ActiveRecord::Base
  attr_accessible :date
  has_many :route_points
end
