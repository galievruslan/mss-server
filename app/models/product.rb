class Product < ActiveRecord::Base
  attr_accessible :name, :price, :external_key
  has_many :order_items 
  validates :name, :price, :external_key, :presence => true
  validates :price, :numericality => {greater_than_or_equal_to: 0}
end
