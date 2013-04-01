class TemplateRoute < ActiveRecord::Base
  attr_accessible :day_of_week, :manager_id, :manager, :template_route_point_ids, :template_route_points_attributes
  has_many :template_route_points, :dependent => :destroy
  belongs_to :manager
  validates :day_of_week, :manager_id, :presence => true
  accepts_nested_attributes_for :template_route_points, :allow_destroy => true
end
