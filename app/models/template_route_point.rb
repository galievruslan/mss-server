class TemplateRoutePoint < ValidableModel
  attr_accessible :shipping_address_id, :template_route_id, :shipping_address, :template_route, :validity
  belongs_to :template_route
  belongs_to :shipping_address
  validates :shipping_address, :presence => true
  validates :shipping_address_id, :uniqueness => { :scope => :template_route_id,
    :message => I18n.t(:one_shipping_address_per_template_route) }
end
