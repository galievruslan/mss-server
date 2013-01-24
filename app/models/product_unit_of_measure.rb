class ProductUnitOfMeasure < ActiveRecord::Base
  attr_accessible :count_in_base_unit, :product_id, :unit_of_measure_id, :product, :unit_of_measure, :base
  belongs_to :unit_of_measure
  belongs_to :product
  validates :count_in_base_unit, :product_id, :unit_of_measure_id, :presence => true
  validates :count_in_base_unit, :numericality => {greater_than_or_equal_to: 0}
  validates :unit_of_measure_id, :uniqueness => { :scope => :product_id,
    :message => "should happen once per product" }
end
