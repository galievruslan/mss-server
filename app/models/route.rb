class Route < ActiveRecord::Base
  attr_accessible :date, :manager_id, :manager, :route_point_ids
  has_many :route_points, :dependent => :destroy
  belongs_to :manager
  validates :date, :manager_id, :presence => true 
end
