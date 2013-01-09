class Product < ActiveRecord::Base
  attr_accessible :name, :price
  has_many :order_items
end
