class RoutePoint < ActiveRecord::Base
  attr_accessible :shipping_address_id, :route_id, :status_id, :status, :route, :shipping_address
  belongs_to :shipping_address
  belongs_to :route
  belongs_to :status
end
