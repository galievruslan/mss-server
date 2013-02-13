class Warehouse < ActiveRecord::Base
  attr_accessible :address, :external_key, :name, :validity, :order_ids
  validates :name, :external_key, :address, :presence => true
  validates :name, :external_key, :uniqueness => { :case_sensitive => false }
  has_many :orders, :dependent => :destroy
end
