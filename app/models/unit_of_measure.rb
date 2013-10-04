class UnitOfMeasure < ActiveRecord::Base
  attr_accessible :name, :validity, :external_key, :product_unit_of_measure_ids, :order_item_ids
  has_many :product_unit_of_measures, :dependent => :destroy
  has_many :order_items, :dependent => :destroy
  has_many :products, :through => :product_unit_of_measures
  has_many :remainders, :dependent => :destroy
  validates :name, :external_key, :presence => true
  validates :name, :external_key, :uniqueness => { :case_sensitive => false }
end
