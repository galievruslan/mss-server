class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :product_id, :quantity, :product
  belongs_to :order
  belongs_to :product
  validates :order_id, :product_id, :quantity, :presence => true
  validates :quantity, :numericality => {:greater_than => 0 }
end
