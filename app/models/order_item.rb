class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :product_id, :quantity
  has_many :orders
  has_many :products
end
