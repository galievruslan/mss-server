class TemplateRoute < ActiveRecord::Base
  attr_accessible :day_of_week, :manager_id, :manager, :template_route_point_ids, :template_route_points_attributes, :validity
  has_many :template_route_points, :dependent => :destroy
  belongs_to :manager
  validates :day_of_week, :manager, :presence => true
  accepts_nested_attributes_for :template_route_points, :allow_destroy => true
    validates :manager_id, :uniqueness => { :scope => :day_of_week,
    :message => I18n.t(:one_template_route_per_day_of_week) }
end
