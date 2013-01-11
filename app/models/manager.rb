class Manager < ActiveRecord::Base
  attr_accessible :name, :external_key
  has_many :orders
  has_many :route_points
end
