class Status < ActiveRecord::Base
  attr_accessible :name, :route_point_ids, :validity
  has_many :route_points, :dependent => :destroy
  validates :name, :presence => true
end
