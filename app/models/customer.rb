class Customer < ActiveRecord::Base
  attr_accessible :name, :external_key
  has_many :shipping_addresses, :dependent => :destroy
  validates :name, :external_key, :presence => true
  validates_associated :shipping_addresses
end
