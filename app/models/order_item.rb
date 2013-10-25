class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :product_id, :quantity, :order, :product, :unit_of_measure, :unit_of_measure_id, :amount
  belongs_to :order
  belongs_to :product
  belongs_to :unit_of_measure
  validates :product, :quantity, :unit_of_measure, :presence => true
  validates :quantity, :numericality => {:greater_than => 0, :only_integer => true}
  validates :product_id, :uniqueness => { :scope => :order_id,
    :message => I18n.t(:one_product_per_order) }
  
  before_save :set_amount
  
  def price_base_unit(price_list)
    product_price = ProductPrice.find_by_price_list_id_and_product_id(price_list.id, self.product.id)
    if product_price
      return product_price.price
    else
      return 0
    end    
  end
  
  def available_unit_of_measures
     unit_of_measure_ids = ProductUnitOfMeasure.where(product_id: self.product.id).select('unit_of_measure_id').map {|x| x.unit_of_measure_id}
     unit_of_measures = UnitOfMeasure.where(id: unit_of_measure_ids) 
     return unit_of_measures
  end
  
  def set_amount
    amount = self.product.price_in_price_list(self.order.price_list_id) * self.quantity * self.product.count_in_unit_of_measure(self.unit_of_measure_id)
    self.amount = amount
  end
end
