class Order < ActiveRecord::Base
  attr_accessible :shipping_address_id, :date, :manager_id, :manager, :shipping_address  
  belongs_to :shipping_address
  belongs_to :manager
  has_many :order_items, :dependent => :destroy
  validates :date, :manager_id, :shipping_address_id, :presence => true
  validates_associated :order_items
end
