class UnitOfMeasure < ActiveRecord::Base
  attr_accessible :name
  has_many :products, :dependent => :destroy
  has_many :product_unit_of_measures, :dependent => :destroy
  validates :name, :presence => true
end
