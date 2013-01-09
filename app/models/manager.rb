class Manager < ActiveRecord::Base
  attr_accessible :name
  has_many :orders
  has_many :route_points
end
