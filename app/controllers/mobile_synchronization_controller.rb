class MobileSynchronizationController < ApplicationController
  
  include MobileSynchronizationHelper
  
  # GET /mobile_client.json
  def mobile_client
    if params[:client_type]
      @mobile_client = MobileClient.where(client_type: params[:client_type]).order("created_at").last    
      respond_to do |format|      
        format.json { render json: @mobile_client }
      end
    else
      @responce = JSON code: 220, description: 'no input parameters'
      respond_to do |format|      
        format.json { render json: @responce }
      end
    end    
  end
  
  # GET /messages.json
  def messages
    @message_ids = current_user.user_messages.where(delivered: false).collect(&:message_id)
    @messages = Message.where(id: @message_ids)
    
    respond_to do |format|      
      format.json { render json: @messages }
    end
        
  end
    
  # GET /datetime.json
  def datetime
    current_date_time = Time.now
    @responce = JSON datetime: current_date_time
    respond_to do |format|      
      format.json { render json: @responce }
    end
  end
    
  # GET /settings.json
  def settings
    if Settings.default_route_point_status_id
      @default_route_point_status_id = Settings.default_route_point_status_id      
    else
      @default_route_point_status_id = nil
    end    
    if Settings.default_route_point_attended_status_id
      @default_route_point_attended_status_id = Settings.default_route_point_attended_status_id      
    else
      @default_route_point_attended_status_id = nil
    end    
    if Settings.default_price_list_id
      @default_price_list_id = Settings.default_price_list_id      
    else
      @default_price_list_id = nil
    end    
    if Settings.photo_width_res and Settings.photo_height_res
      @photo_width_res = Settings.photo_width_res
      @photo_height_res = Settings.photo_height_res
    else
      @photo_width_res = nil
      @photo_height_res = nil
    end
    if Settings.message_pull_frequency
      @message_pull_frequency = Settings.message_pull_frequency      
    else
      @message_pull_frequency = nil
    end
    @responce = JSON default_route_point_status_id: @default_route_point_status_id,
        default_route_point_attended_status_id: @default_route_point_attended_status_id,
        default_price_list_id: @default_price_list_id, photo_width_res: @photo_width_res,
        photo_height_res: @photo_height_res, message_pull_frequency: @message_pull_frequency
    respond_to do |format|     
      format.json { render json: @responce }
    end 
  end
  
  # GET /customers.json
  def customers
    @manager_id = current_user.manager_id
    if @manager_id
      @shipping_address_ids = ManagerShippingAddress.where(manager_id: @manager_id).collect(&:shipping_address_id)
      @manager_customer_ids = ShippingAddress.where(id: @shipping_address_ids).collect(&:customer_id)
      if params[:updated_at]
        @customers = ShippingAddress.where(id: @shipping_address_ids).joins(:manager_shipping_addresses, :customer).uniq.select("customers.id, customers.address, customers.name, customers.external_key, customers.updated_at, customers.created_at, customers.debt, manager_shipping_addresses.validity").where("customers.updated_at >= ? OR manager_shipping_addresses.updated_at >= ?", params[:updated_at], params[:updated_at]).page(page).per(page_size) 
        # @customers = Customer.where(id: @manager_customer_ids).where("updated_at >= ?", params[:updated_at]).page(page).per(page_size)
      else
        @customers = ShippingAddress.where(id: @shipping_address_ids).joins(:manager_shipping_addresses, :customer).uniq.select("customers.id, customers.address, customers.name, customers.external_key, customers.updated_at, customers.created_at, customers.debt, manager_shipping_addresses.validity").page(page).per(page_size)
        # @customers = Customer.where(id: @manager_customer_ids).page(page).per(page_size)
      end
      respond_to do |format|
        format.json { render json: @customers }
      end
    else
      respond_to do |format|
        @responce = JSON code: 210, description: 'manager is not defined for the current user'
        format.json { render json: @responce }
      end
    end    
  end 
  
  # GET /shipping_addresses.json
  def shipping_addresses
    @manager_id = current_user.manager_id
    if @manager_id      
      if params[:updated_at]
        @shipping_addresses = ManagerShippingAddress.where(manager_id: @manager_id).joins(:shipping_address).select("shipping_addresses.id, shipping_addresses.customer_id, shipping_addresses.name, shipping_addresses.address, shipping_addresses.external_key, manager_shipping_addresses.validity, shipping_addresses.created_at, shipping_addresses.updated_at").where("shipping_addresses.updated_at >= ? OR manager_shipping_addresses.updated_at >= ?", params[:updated_at], params[:updated_at]).page(page).per(page_size)        
      else        
        @shipping_addresses = ManagerShippingAddress.where(manager_id: @manager_id).joins(:shipping_address).select("shipping_addresses.id, shipping_addresses.customer_id, shipping_addresses.name, shipping_addresses.address, shipping_addresses.external_key, manager_shipping_addresses.validity, shipping_addresses.created_at, shipping_addresses.updated_at").page(page).per(page_size)
      end
      respond_to do |format|
        format.json { render json: @shipping_addresses }
      end 
    else
      respond_to do |format|
        @responce = JSON code: 210, description: 'manager is not defined for the current user'
        format.json { render json: @responce }
      end
    end
  end 
  
  # GET /manager.json
  def manager
    @manager_id = current_user.manager_id
    if @manager_id   
      @manager = Manager.find(@manager_id)
      respond_to do |format|
        format.json { render json: @manager }
      end 
    else
      respond_to do |format|
        @responce = JSON code: 210, description: 'manager is not defined for the current user'
        format.json { render json: @responce }
      end 
    end    
  end
  
  # GET /manager_shipping_addresses.json
  def manager_shipping_addresses
    @manager_id = current_user.manager_id
    if @manager_id
      if params[:updated_at]
        @manager_shipping_addresses = ManagerShippingAddress.where("updated_at >= ? and manager_id = ?", params[:updated_at], @manager_id).page(page).per(page_size)
      else
        @manager_shipping_addresses = ManagerShippingAddress.where(manager_id: @manager_id).page(page).per(page_size)
      end
      respond_to do |format|
        format.json { render json: @manager_shipping_addresses }
      end 
    else
      respond_to do |format|
        @responce = JSON code: 210, description: 'manager is not defined for the current user'
        format.json { render json: @responce }
      end 
    end
  end
  
  # GET /categories.json
  def categories
    if params[:updated_at]
      @categories = Category.where("updated_at >= ?", params[:updated_at]).page(page).per(page_size)
    else
      @categories = Category.page(page).per(page_size)
    end 
    respond_to do |format|      
      format.json { render json: @categories }
    end 
  end
  
  # GET /products.json
  def products
    if params[:updated_at]
      @products = Product.where("updated_at >= ?", params[:updated_at]).page(page).per(page_size)
    else
      @products = Product.page(page).per(page_size)
    end 
    respond_to do |format|
      format.json { render json: @products }
    end 
  end
  
  # GET /product_unit_of_measures.json
  def product_unit_of_measures
    if params[:updated_at]
      @product_unit_of_measures = ProductUnitOfMeasure.where("updated_at >= ?", params[:updated_at]).page(page).per(page_size)
    else
      @product_unit_of_measures = ProductUnitOfMeasure.page(page).per(page_size)
    end 
    respond_to do |format|
      format.json { render json: @product_unit_of_measures }
    end 
  end
  
  # GET /product_prices.json
  def product_prices
    if params[:updated_at]
      @product_prices = ProductPrice.where("updated_at >= ?", params[:updated_at]).page(page).per(page_size)
    else
      @product_prices = ProductPrice.page(page).per(page_size)
    end 
    respond_to do |format|
      format.json { render json: @product_prices }
    end 
  end
  
  # GET /warehouses.json
  def warehouses
    @manager_id = current_user.manager_id
    if @manager_id
      if params[:updated_at]
        @warehouses = ManagerWarehouse.where(manager_id: @manager_id).joins(:warehouse).select("warehouses.id, warehouses.name, warehouses.address, warehouses.external_key, manager_warehouses.validity, warehouses.created_at, warehouses.updated_at").where("warehouses.updated_at >= ? OR manager_warehouses.updated_at >= ?", params[:updated_at], params[:updated_at]).page(page).per(page_size)        
      else        
        @warehouses = ManagerWarehouse.where(manager_id: @manager_id).joins(:warehouse).select("warehouses.id, warehouses.name, warehouses.address, warehouses.external_key, manager_warehouses.validity, warehouses.created_at, warehouses.updated_at").page(page).per(page_size)
      end
      
      respond_to do |format|
        format.json { render json: @warehouses }
      end 
    else
      respond_to do |format|
        @responce = JSON code: 210, description: 'manager is not defined for the current user'
        format.json { render json: @responce }
      end
    end     
  end
  
  # GET /statuses.json
  def statuses
    if params[:updated_at]
      @statuses = Status.where("updated_at >= ?", params[:updated_at]).page(page).per(page_size)
    else
      @statuses = Status.page(page).per(page_size)
    end 
    respond_to do |format|
      format.json { render json: @statuses }
    end 
  end
  
  # GET /price_lists.json
  def price_lists
    if params[:updated_at]
      @price_lists = PriceList.where("updated_at >= ?", params[:updated_at]).page(page).per(page_size)
    else
      @price_lists = PriceList.page(page).per(page_size)
    end 
    respond_to do |format|
      format.json { render json: @price_lists }
    end 
  end
  
  # GET /unit_of_measures.json
  def unit_of_measures
    if params[:updated_at]
      @unit_of_measures = UnitOfMeasure.where("updated_at >= ?", params[:updated_at]).page(page).per(page_size)
    else
      @unit_of_measures = UnitOfMeasure.page(page).per(page_size)
    end 
    respond_to do |format|
      format.json { render json: @unit_of_measures }
    end 
  end
  
  # GET /template_routes.json
  def template_routes
    @manager_id = current_user.manager_id
    if @manager_id
      if params[:updated_at]        
          @template_routes = TemplateRoute.where("updated_at >= ? and manager_id = ?", params[:updated_at], @manager_id).page(page).per(page_size)             
      else        
          @template_routes = TemplateRoute.where(manager_id: @manager_id).page(page).per(page_size)           
      end
      
      respond_to do |format|
        format.json { render json: @template_routes }
      end
    else
      respond_to do |format|
        @responce = JSON code: 210, description: 'manager is not defined for the current user'
        format.json { render json: @responce }
      end 
    end 
  end
  
  # GET /template_route_points.json
  def template_route_points
    @manager_id = current_user.manager_id
    if @manager_id
      @template_route_ids = TemplateRoute.where(manager_id: @manager_id).collect(&:id)
      if params[:updated_at]        
          @template_route_points = TemplateRoutePoint.where(template_route_id: @template_route_ids,).where("updated_at >= ?",params[:updated_at]).page(page).per(page_size)             
      else        
          @template_route_points = TemplateRoutePoint.where(template_route_id: @template_route_ids).page(page).per(page_size)           
      end
      
      respond_to do |format|
        format.json { render json: @template_route_points }
      end
    else
      respond_to do |format|
        @responce = JSON code: 210, description: 'manager is not defined for the current user'
        format.json { render json: @responce }
      end 
    end    
  end
  
  # GET /remainders.json
  def remainders
    @manager_id = current_user.manager_id
    if @manager_id
      @warehouse_ids = ManagerWarehouse.where(manager_id: @manager_id, validity: true).collect(&:warehouse_id)      
      if params[:updated_at]        
          @remainders = Remainder.where(warehouse_id: @warehouse_ids).where("updated_at >= ?",params[:updated_at]).page(page).per(page_size)             
      else        
          @remainders = Remainder.where(warehouse_id: @warehouse_ids).page(page).per(page_size)           
      end
      
      respond_to do |format|
        format.json { render json: @remainders }
      end      
    else
      respond_to do |format|
        @responce = JSON code: 210, description: 'manager is not defined for the current user'
        format.json { render json: @responce }
      end 
    end    
  end
  
  # POST /routes.json
  def routes
    @manager_id = current_user.manager_id
    @route = Route.find_by_manager_id_and_date(@manager_id, params[:route][:date])
    Route.transaction do        
      begin
        if @route
          params[:route][:route_points_attributes].values.each do |route_point|
            @route_point = @route.route_points.find_by_shipping_address_id(route_point[:shipping_address_id])
            if @route_point
              @route_point.update_attributes(route_point)
            else
              @route.route_points.create(route_point)
            end        
          end      
          respond_to do |format|
            @responce = JSON code: 101, description: 'updated successfully'
            format.json { render json: @responce, status: :ok, location: @route }
          end
        else
          params[:route][:manager_id] = @manager_id
          @route = Route.new(params[:route])
          respond_to do |format|
            if @route.save
              @responce = JSON code: 100, description: 'created successfully'
              format.json { render json: @responce, status: :created, location: @route }
            else
              @responce = JSON code: 200, description: 'the data format is not valid'
              format.json { render json: @responce, status: :unprocessable_entity }
            end
          end
        end      
        rescue ActiveRecord::StatementInvalid
      end
    end
  end
  
  # POST /orders.json
  def orders
    @manager_id = current_user.manager_id
    @datetime = params[:order][:date]
    @shipping_address_id = params[:order][:shipping_address_id]
    @route = Route.find_by_date_and_manager_id(@datetime.to_date, @manager_id)
    if @route
      @route_point = @route.route_points.find_by_shipping_address_id(@shipping_address_id)
      if @route_point
        @route_point_id = @route_point.id        
      else
        @route_point_id = nil
      end
    else
      @route_point_id = nil
    end
    
    @guid = params[:order][:guid]    
    @order = Order.find_by_guid(@guid)
    Order.transaction do
      begin
        if @order      
          respond_to do |format|
            @responce = JSON code: 100, description: 'already exists'
            format.json { render json: @responce, status: :ok, location: @order }
          end
        else
          params[:order][:complete] = true
          params[:order][:manager_id] = @manager_id
          params[:order][:route_point_id] = @route_point_id
          @order = Order.new(params[:order])
          respond_to do |format|
            if @order.save
              @responce = JSON code: 100, description: 'created successfully'
              format.json { render json: @responce, status: :created, location: @order }
            else
              @responce = JSON code: 200, description: 'the data format is not valid'
              format.json { render json: @responce, status: :unprocessable_entity }
            end
          end
        end
        rescue ActiveRecord::StatementInvalid
      end
    end   
  end
  
  # POST /audit_documents.json
  def audit_documents
    @manager_id = current_user.manager_id    
    @guid = params[:audit_document][:guid]    
    @audit_document = AuditDocument.find_by_guid(@guid)
    AuditDocument.transaction do
      begin
        if @audit_document      
          respond_to do |format|
            @responce = JSON code: 100, description: 'already exists'
            format.json { render json: @responce, status: :ok, location: @audit_document }
          end
        else          
          @audit_document = AuditDocument.new(params[:audit_document])
          @audit_document.manager_id = @manager_id
          respond_to do |format|
            if @audit_document.save
              @responce = JSON code: 100, description: 'created successfully'
              format.json { render json: @responce, status: :created, location: @audit_document }
            else
              @responce = JSON code: 200, description: 'the data format is not valid'
              format.json { render json: @responce, status: :unprocessable_entity }
            end
          end
        end
        rescue ActiveRecord::StatementInvalid
      end
    end   
  end
  
  # POST /client_information.json
  def client_information
    @user = current_user
    if params[:client_type] and params[:client_version]
      @user.update_attributes(client_type: params[:client_type], client_version: params[:client_version])
      @responce = JSON code: 101, description: 'updated successfully'
      respond_to do |format|      
        format.json { render json: @responce, status: :ok}
      end
    else
      @responce = JSON code: 220, description: 'no input parameters'
      respond_to do |format|      
        format.json { render json: @responce, status: :ok}
      end
    end         
  end  
  
  # POST /route_point_photos.json
  def route_point_photos
    @manager_id = current_user.manager_id
    @datetime = params[:date]
    @shipping_address_id = params[:shipping_address_id]
    @route = Route.find_by_date_and_manager_id(@datetime.to_date, @manager_id)
    if @route
      @route_point = @route.route_points.find_by_shipping_address_id(@shipping_address_id)
      if @route_point
        @route_point_id = @route_point.id        
      else
        @route_point_id = nil
      end
    else
      @route_point_id = nil
    end
    
    @guid = params[:route_point_photo][:guid]    
    @route_point_photo = RoutePointPhoto.find_by_guid(@guid)
    RoutePointPhoto.transaction do
      begin
        if @route_point_photo      
          respond_to do |format|
            @responce = JSON code: 100, description: 'already exists'
            format.json { render json: @responce, status: :ok, location: @order }
          end
        else
          params[:route_point_photo][:route_point_id] = @route_point_id
          @route_point_photo = RoutePointPhoto.new(params[:route_point_photo])
          respond_to do |format|
            if @route_point_photo.save
              @responce = JSON code: 100, description: 'created successfully'
              format.json { render json: @responce, status: :created, location: @order }
            else
              @responce = JSON code: 200, description: 'the data format is not valid'
              format.json { render json: @responce, status: :unprocessable_entity }
            end
          end
        end
        rescue ActiveRecord::StatementInvalid
      end
    end     
  end  
  
  # POST /locations.json
  def locations
    params[:location][:user_id] = current_user.id
    @location = Location.find_by_timestamp_and_user_id(params[:location][:timestamp], current_user.id)
    Location.transaction do
      begin
        if @location
          respond_to do |format|
            @responce = JSON code: 100, description: 'already exists'
            format.json { render json: @responce, status: :ok, location: @order }
          end
        else
          @location = Location.new(params[:location])
          respond_to do |format|      
            if @location.save
              @responce = JSON code: 100, description: 'created successfully'
              format.json { render json: @responce, status: :created, location: @order }
            else
              @responce = JSON code: 200, description: 'the data format is not valid'
              format.json { render json: @responce, status: :unprocessable_entity }
            end
          end
        end
        rescue ActiveRecord::StatementInvalid
      end
    end           
  end   
end
