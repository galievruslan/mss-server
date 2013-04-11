class Route < ActiveRecord::Base
  attr_accessible :date, :external_key, :manager_id, :manager, :route_point_ids, :route_points_attributes
  has_many :route_points, :dependent => :destroy
  belongs_to :manager
  validates :date, :manager_id, :presence => true 
  accepts_nested_attributes_for :route_points, :allow_destroy => true
  validates :external_key, :uniqueness => true, :allow_nil => true
end
