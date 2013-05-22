class ManagerShippingAddress < ActiveRecord::Base
  attr_accessible :manager_id, :shipping_address_id, :manager, :shipping_address, :validity
  belongs_to :manager
  belongs_to :shipping_address
  validates :manager, :shipping_address, :presence => true
  validates :shipping_address_id, :uniqueness => { :scope => :manager_id,
    :message => I18n.t(:one_manager_shipping_address_per_manager) }
end
