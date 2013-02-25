class ManagerShippingAddress < ActiveRecord::Base
  attr_accessible :manager_id, :shipping_address_id, :manager, :shipping_address
  belongs_to :manager
  belongs_to :shipping_address
  validates :manager_id, :shipping_address_id, :presence => true
end
