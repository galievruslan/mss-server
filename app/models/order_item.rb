class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :product_id, :quantity, :order, :product, :unit_of_measure, :unit_of_measure_id
  belongs_to :order
  belongs_to :product
  belongs_to :unit_of_measure
  validates :product, :quantity, :unit_of_measure, :presence => true
  validates :quantity, :numericality => {:greater_than => 0 }
end
