class RoutePoint < ActiveRecord::Base
  attr_accessible :customer_id, :route_id, :status_id
  belongs_to :customer
  belongs_to :route
  belongs_to :status
end
