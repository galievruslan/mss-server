class Route < ActiveRecord::Base
  attr_accessible :date, :manager_id, :manager
  has_many :route_points
  belongs_to :manager
end
