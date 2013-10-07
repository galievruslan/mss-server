class RoutePoint < ActiveRecord::Base
  attr_accessible :shipping_address_id, :route_id, :status_id, :shipping_address, :status, :route
  has_many :orders
  has_many :route_point_photos
  belongs_to :shipping_address
  belongs_to :route
  belongs_to :status
  validates :shipping_address,:status, :presence => true
  validates :shipping_address_id, :uniqueness => { :scope => :route_id,
    :message => I18n.t(:one_shipping_address_per_route) }
end
