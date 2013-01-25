class Product < ActiveRecord::Base
  attr_accessible :name, :external_key, :validity
  has_many :order_items, :dependent => :destroy
  has_many :product_unit_of_measures, :dependent => :destroy
  has_many :price_list_lines , :dependent => :destroy
  validates :name, :external_key, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }
end
