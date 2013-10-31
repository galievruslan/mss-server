class Manager < ValidableModel
  attr_accessible :name, :external_key, :validity, :order_ids, :route_ids, :template_route_ids, :default_warehouse_id, :default_warehouse, :audit_document_ids
  has_many :orders, :dependent => :destroy
  has_many :routes, :dependent => :destroy
  has_many :template_routes, :dependent => :destroy
  has_many :manager_shipping_addresses, :dependent => :destroy
  has_many :manager_warehouses, :dependent => :destroy
  has_many :shipping_addresses, :through => :manager_shipping_addresses
  has_many :warehouses, :through => :manager_warehouses
  has_many :audit_documents, :dependent => :destroy
  belongs_to :default_warehouse , :class_name => "Warehouse", :foreign_key => "default_warehouse_id"
  validates :name, :external_key, :presence => true
  validates :external_key, :uniqueness => { :case_sensitive => false }
  
  def self.best_managers(start_date, end_date)
    best_manager_ids = Order.where(:date => start_date.beginning_of_day..end_date.end_of_day, :complete => true).group("manager_id").
                    select("manager_id, sum(amount) as amount").order("amount DESC").limit(3)
  end
  
  def set_invalid
    self.manager_shipping_addresses.each do |manager_shipping_address|
      manager_shipping_address.set_invalid
    end
    self.manager_warehouses.each do |manager_warehouse|
      manager_warehouse.set_invalid
    end
    super
  end  
end
