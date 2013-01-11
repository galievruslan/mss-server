class Customer < ActiveRecord::Base
  attr_accessible :name, :external_key
  has_many :shipping_addresses
end
