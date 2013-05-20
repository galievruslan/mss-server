class Order < ActiveRecord::Base
  attr_accessible :shipping_address_id, :date, :shipping_date, :manager_id, :route_point_id, :exported_at, :manager, :shipping_address, :warehouse_id, :warehouse, :comment, :price_list_id, :price_list, :order_item_ids, :order_items_attributes
  belongs_to :shipping_address
  belongs_to :manager
  belongs_to :warehouse
  belongs_to :price_list
  belongs_to :route_point
  has_many :order_items, :dependent => :destroy
  validates :date, :shipping_date, :manager, :shipping_address, :warehouse, :price_list, :presence => true
  accepts_nested_attributes_for :order_items, :allow_destroy => true  
  
  def order_amount    
    order_amount = 0    
    self.order_items.each do |order_item|
      product = order_item.product
      price = order_item.price_base_unit(self.price_list)
        
      product_count_in_base_unit = product.product_unit_of_measures.find_by_unit_of_measure_id(order_item.unit_of_measure.id).count_in_base_unit
      order_item_amount = order_item.quantity * product_count_in_base_unit * price
      order_amount = order_amount + order_item_amount
    end
    return order_amount
  end
  
end
