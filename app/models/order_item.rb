class OrderItem < ActiveRecord::Base
  attr_accessible :order_id, :product_id, :quantity, :order, :product, :unit_of_measure, :unit_of_measure_id
  belongs_to :order
  belongs_to :product
  belongs_to :unit_of_measure
  validates :product, :quantity, :unit_of_measure, :presence => true
  validates :quantity, :numericality => {:greater_than => 0 }
  validates :product_id, :uniqueness => { :scope => :order_id,
    :message => I18n.t(:one_product_per_order) }
  
  def price_base_unit(price_list)
    product_price = ProductPrice.find_by_price_list_id_and_product_id(price_list.id, self.product.id)
    if product_price
      return product_price.price
    else
      return 0
    end    
  end
end
