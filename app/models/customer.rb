class Customer < ActiveRecord::Base
  attr_accessible :name, :external_key, :validity, :shipping_address_ids
  has_many :shipping_addresses, :dependent => :destroy
  validates :name, :external_key, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }
end