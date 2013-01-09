class Customer < ActiveRecord::Base
  attr_accessible :name
  has_many :shipping_addresses
end
