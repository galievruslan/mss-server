class Route < ActiveRecord::Base
  attr_accessible :date, :manager_id, :manager, :route_point_ids, :route_points_attributes
  has_many :route_points, :dependent => :destroy
  belongs_to :manager
  validates :date, :manager_id, :presence => true 
  accepts_nested_attributes_for :route_points, :allow_destroy => true
  validates :manager_id, :uniqueness => { :scope => :date,
    :message => I18n.t(:one_route_per_date) }
end
