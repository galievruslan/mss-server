class RoutePoint < ActiveRecord::Base
  attr_accessible :shipping_address_id, :route_id, :status_id, :shipping_address, :status, :route
  has_many :orders
  belongs_to :shipping_address
  belongs_to :route
  belongs_to :status
  validates :shipping_address,:status, :presence => true
end
