class ShippingAddress < ActiveRecord::Base
  attr_accessible :address, :customer_id, :name, :external_key, :customer, :validity
  belongs_to :customer  
  has_many :orders, :dependent => :destroy
  has_many :route_points, :dependent => :destroy
  has_many :template_route_points, :dependent => :destroy
  validates :name, :address, :customer_id, :external_key, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }
end
