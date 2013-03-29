class RoutePoint < ActiveRecord::Base
  attr_accessible :shipping_address_id, :route_id, :status_id, :shipping_address, :status, :route
  belongs_to :shipping_address
  belongs_to :route
  belongs_to :status
  validates :shipping_address_id,:status_id, :presence => true
end
