class TemplateRoutePoint < ActiveRecord::Base
  attr_accessible :shipping_address_id, :template_route_id, :shipping_address, :template_route
  belongs_to :template_route
  belongs_to :shipping_address
  validates :shipping_address_id, :template_route_id, :presence => true
end
