class UnitOfMeasure < ActiveRecord::Base
  attr_accessible :name, :validity, :external_key
  has_many :product_unit_of_measures, :dependent => :destroy
  has_many :order_items, :dependent => :destroy
  validates :name, :external_key, :presence => true
  validates :name, :external_key, :uniqueness => { :case_sensitive => false }
end
