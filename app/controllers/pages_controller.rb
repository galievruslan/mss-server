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
  end
end
