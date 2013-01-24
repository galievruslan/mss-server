class Product < ActiveRecord::Base
  attr_accessible :name, :price, :external_key, :validity
  has_many :order_items, :dependent => :destroy
  has_many :product_unit_of_measures, :dependent => :destroy
  validates :name, :price, :external_key, :presence => true
  validates :price, :numericality => {greater_than_or_equal_to: 0}
  validates :external_key, :uniqueness => { :case_sensitive => false }
end
