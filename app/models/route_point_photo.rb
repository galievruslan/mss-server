class RoutePointPhoto < ActiveRecord::Base
  attr_accessible :comment, :photo, :route_point_id, :route_point, :guid
  validates :route_point_id, :photo, :presence => true 
  belongs_to :route_point
  mount_uploader :photo, PhotoUploader
end
