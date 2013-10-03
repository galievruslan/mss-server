class Remainder < ActiveRecord::Base
  attr_accessible :quantity, :product_id, :unit_of_measure_id, :warehouse_id, :product, :unit_of_measure, :warehouse
  belongs_to :warehouse
  belongs_to :product
  belongs_to :unit_of_measure
  validates :warehouse_id, :product_id, :unit_of_measure_id, :quantity, :presence => true
  validates :quantity, :numericality => {:greater_than_or_equal_to => 0 }
  validates :product_id, :uniqueness => { :scope => [:warehouse_id,:unit_of_measure_id], 
    :message => I18n.t(:one_product_and_unit_in_warehouse) }
end
