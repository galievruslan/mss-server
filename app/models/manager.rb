class Manager < ActiveRecord::Base
  attr_accessible :name, :external_key, :validity, :order_ids, :route_ids, :template_route_ids, :default_warehouse_id, :default_warehouse
  has_many :orders, :dependent => :destroy
  has_many :routes, :dependent => :destroy
  has_many :template_routes, :dependent => :destroy
  has_many :manager_shipping_addresses, :dependent => :destroy
  has_many :shipping_addresses, :through => :manager_shipping_addresses
  belongs_to :default_warehouse , :class_name => "Warehouse", :foreign_key => "default_warehouse_id"
  validates :name, :external_key, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }
end
