class Product < ActiveRecord::Base
  attr_accessible :name, :external_key, :validity, :order_item_ids, :product_unit_of_measure_ids, :product_price_ids, :category_id, :category
  has_many :order_items, :dependent => :destroy
  has_many :product_unit_of_measures, :dependent => :destroy
  has_many :product_prices , :dependent => :destroy
  has_many :price_lists, :through => :product_prices
  has_many :unit_of_measures, :through => :product_unit_of_measures 
  validates :name, :external_key, :category, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }
  belongs_to :category
  
  def price_in_price_list(price_list_id)
    ProductPrice.find_by_product_id_and_price_list_id(self.id, price_list_id).price
  end
  
  def count_in_unit_of_measure(unit_of_measure_id)
    ProductUnitOfMeasure.find_by_product_id_and_unit_of_measure_id(self.id, unit_of_measure_id).count_in_base_unit
  end
end
