class Warehouse < ActiveRecord::Base
  attr_accessible :address, :external_key, :name, :validity, :order_ids
  validates :name, :external_key, :address, :presence => true
  validates :name, :external_key, :uniqueness => { :case_sensitive => false }
  has_many :orders, :dependent => :destroy
  
  def self.best_warehouses(start_date, end_date)
    best_manager_ids = Order.where(:date => start_date.beginning_of_day..end_date.end_of_day, :complete => true).group("warehouse_id").
                    select("warehouse_id, sum(amount) as amount").order("amount DESC").limit(3)
  end
end
