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
    if params[:with_order_items]
      respond_to do |format|
        format.html
        format.xls {render :template => 'reports/orders_with_items.xls.erb'}
      end   
    else
      respond_to do |format|
        format.html
        format.xls {render :template => 'reports/orders.xls.erb'}
      end
    end    
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
  
  # GET /reports/customer_debts
  def customer_debts
    authorize! :view, :reports
    @customers = Customer.all
    @search = Customer.search(params[:q])
    @customer_debts = @search.result
  end
  
  # GET /reports/remainders
  def remainders
    authorize! :view, :reports
    @products = Product.all
    @warehouses = Warehouse.all
    @unit_of_measures = UnitOfMeasure.all
    @search = Remainder.search(params[:q])
    @remainders = @search.result
  end
  
  # GET /reports/locations
  def locations
    authorize! :view, :reports
    @managers = Manager.all
    @search = Location.search(params[:q])
    if params[:q] and params[:q][:user_manager_id_eq] != ''
      if params[:q][:timestamp_gt] != ''
        @locations = @search.result
        @polyline_point = [] 
        @polyline = []         
        @locations.each do |loc|
          @polyline_point << { :lng => loc[:longitude], :lat => loc[:latitude]}
        end
        @polyline << @polyline_point
        @polyline =  @polyline.to_json
      else
        @locations = @search.result.last
        @polyline = []
      end      
      @markers = @locations.to_gmaps4rails do |location, marker|
        if location == @locations.first 
          marker.infowindow render_to_string(:partial => "/reports/location", :locals => { :object => location})
          marker.picture({
                          :picture => '/assets/start.png',
                          :width   => 24,
                          :height  => 24,
                          :marker_anchor => [12, 24]
                         })
          marker.title   location.timestamp.to_s
        elsif location == @locations.last 
          marker.infowindow render_to_string(:partial => "/reports/location", :locals => { :object => location})
          marker.picture({
                          :picture => '/assets/finish.png',
                          :width   => 24,
                          :height  => 24,
                          :marker_anchor => [12, 24]
                         })
          marker.title   location.timestamp.to_s
        else
          marker.infowindow render_to_string(:partial => "/reports/location", :locals => { :object => location})
          marker.picture({
                          :picture => '/assets/point.png',
                          :width   => 8,
                          :height  => 8,
                          :marker_anchor => [4, 4]
                         })
          marker.title   location.timestamp.to_s
        end        
      end
    end
  end
  
  # GET /reports/audit_documents
  def audit_documents
    authorize! :view, :reports
    @managers = Manager.all
    @shipping_addresses = ShippingAddress.all
    @customers = Customer.all    
    @search = AuditDocument.search(params[:q])
    @audit_documents = @search.result
    
    if params[:with_audit_document_items]
      respond_to do |format|
        format.html
        format.xls {render :template => 'reports/audit_documents_with_items.xls.erb'}
      end   
    else
      respond_to do |format|
        format.html
        format.xls {render :template => 'reports/audit_documents.xls.erb'}
      end
    end 
  end
end
