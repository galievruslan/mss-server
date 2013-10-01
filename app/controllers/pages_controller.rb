class PagesController < ApplicationController
  require 'yaml'
  include MobileSynchronizationHelper
  def index
    @best_day_managers = Manager.best_managers(Date.today, Date.today)
    @best_month_managers = Manager.best_managers(Date.today.ago(1.month), Date.today)
    @best_day_warehouses = Warehouse.best_warehouses(Date.today, Date.today)
    @best_month_warehouses = Warehouse.best_warehouses(Date.today.ago(1.month), Date.today)
  end
  
  def bali
    @setting = YAML.load_file("#{Rails.root}/config/settings.local.yml")
    @manager_shipping_address_ids = ManagerShippingAddress.where(manager_id: 4).select('shipping_address_id').map {|x| x.shipping_address_id}
    if params[:updated_at]
      @shipping_addresses = ShippingAddress.where(id: @manager_shipping_address_ids).joins(:manager_shipping_addresses).select(
      "shipping_addresses.id, shipping_addresses.customer_id, shipping_addresses.name, shipping_addresses.address,
      shipping_addresses.external_key, manager_shipping_addresses.validity, shipping_addresses.created_at, shipping_addresses.updated_at").where("shipping_addresses.updated_at >= ? OR manager_shipping_addresses.updated_at >= ?", params[:updated_at], params[:updated_at]).page(page).per(page_size)        
    else        
      @shipping_addresses = ShippingAddress.where(id: @manager_shipping_address_ids).joins(:manager_shipping_addresses).select(
      "shipping_addresses.id, shipping_addresses.customer_id, shipping_addresses.name, shipping_addresses.address,
      shipping_addresses.external_key, manager_shipping_addresses.validity, shipping_addresses.created_at, shipping_addresses.updated_at").page(page).per(page_size)
    end
  end
end
