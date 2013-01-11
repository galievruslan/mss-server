class ShippingAddress < ActiveRecord::Base
  attr_accessible :address, :customer_id, :name,:external_key
  belongs_to :customer  
  has_many :orders
  has_many :route_points
end
