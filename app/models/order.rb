class Order < ActiveRecord::Base
  attr_accessible :shipping_address_id, :date, :manager_id, :exported_at, :manager, :shipping_address, :warehouse_id, :warehouse, :comment, :price_list_id, :price_list
  belongs_to :shipping_address
  belongs_to :manager
  belongs_to :warehouse
  belongs_to :price_list
  has_many :order_items, :dependent => :destroy
  validates :date, :manager_id, :shipping_address_id, :warehouse_id,:price_list_id, :presence => true
  validates_associated :order_items
end
