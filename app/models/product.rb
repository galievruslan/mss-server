class Product < ActiveRecord::Base
  attr_accessible :name, :price, :external_key
  has_many :order_items 
end
