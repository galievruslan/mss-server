class ReportsController < ApplicationController
  
  # GET /reports
  def index
    authorize! :view, :reports
  end 
  
  # GET /reports/orders
  def orders
    authorize! :view, :reports
    @managers = Manager.all
    @warehouses = Warehouse.all
    @price_lists = PriceList.all
    @customers = Customer.all
    @shipping_addresses = ShippingAddress.all
    @search = Order.search(params[:q])
    @orders = @search.result
  end 
  
  # GET /reports/routes
  def routes
    authorize! :view, :reports
    @managers = Manager.all
    @customers = Customer.all
    @shipping_addresses = ShippingAddress.all
    @statuses = Status.all
    @search = RoutePoint.search(params[:q])
    @route_points = @search.result
  end
  
  # GET /reports/template_routes
  def template_routes
    authorize! :view, :reports
    @managers = Manager.all
    @customers = Customer.all
    @shipping_addresses = ShippingAddress.all
    @statuses = Status.all
    @days_of_week = [0,1,2,3,4,5,6]
    @search = TemplateRoutePoint.search(params[:q])
    @template_route_points = @search.result
  end
  
end
