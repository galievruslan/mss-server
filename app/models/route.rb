class Route < ActiveRecord::Base
  attr_accessible :date, :manager_id, :manager
  has_many :route_points, :dependent => :destroy
  belongs_to :manager
end
