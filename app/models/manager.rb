class Manager < ActiveRecord::Base
  attr_accessible :name, :external_key
  has_many :orders
  has_many :routes
  validates :name, :external_key, :presence => true
end
