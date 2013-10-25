class ShippingAddress < ActiveRecord::Base
  attr_accessible :address, :customer_id, :name, :external_key, :customer, :validity, :order_ids, :route_point_ids, :template_route_point_ids, :audit_document_ids
  belongs_to :customer  
  has_many :orders, :dependent => :destroy
  has_many :route_points, :dependent => :destroy
  has_many :template_route_points, :dependent => :destroy
  has_many :manager_shipping_addresses, :dependent => :destroy
  has_many :managers, :through => :manager_shipping_addresses
  has_many :audit_documents, :dependent => :destroy
  validates :name, :address, :customer, :external_key, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }
end
