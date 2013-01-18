class TemplateRoute < ActiveRecord::Base
  attr_accessible :day_of_week, :manager_id
  has_many :template_route_points, :dependent => :destroy
  belongs_to :manager
  validates :day_of_week, :manager_id, :presence => true
end
