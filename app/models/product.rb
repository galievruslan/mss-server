class Product < ActiveRecord::Base
  attr_accessible :name, :external_key, :validity, :order_item_ids, :product_unit_of_measure_ids, :product_price_ids, :category_id, :category
  has_many :order_items, :dependent => :destroy
  has_many :product_unit_of_measures, :dependent => :destroy
  has_many :product_prices , :dependent => :destroy
  validates :name, :external_key, :category_id, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }
  belongs_to :category
end
