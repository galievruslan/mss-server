class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :product_id, :quantity, :product
  belongs_to :order
  belongs_to :product
end
