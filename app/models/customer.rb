class Customer < ActiveRecord::Base
  attr_accessible :name, :external_key, :validity, :shipping_address_ids, :address
  has_many :shipping_addresses, :dependent => :destroy
  validates :name, :external_key, :address, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }
end