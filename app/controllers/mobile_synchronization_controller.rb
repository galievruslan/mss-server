class MobileSynchronizationController < ApplicationController
  
  include MobileSynchronizationHelper
  
  # GET /customers.json
  def customers    
    if params[:updated_at]
      @customers = Customer.where("updated_at >= ?", params[:updated_at]).page(page).per(page_size)
    else
      @customers = Customer.page(page).per(page_size)
    end
    respond_to do |format|
      format.json { render json: @customers }
    end 
  end 
  
  # GET /shipping_addresses.json
  def shipping_addresses    
    if params[:updated_at]
      @shipping_addresses = ShippingAddress.where("updated_at >= ?", params[:updated_at]).page(page).per(page_size)
    else
      @shipping_addresses = ShippingAddress.page(page).per(page_size)
    end
    respond_to do |format|
      format.json { render json: @shipping_addresses }
    end 
  end 
  
  # GET /managers.json
  def managers
    if params[:updated_at]
      @managers = Manager.where("updated_at >= ?", params[:updated_at]).page(page).per(page_size)
    else
      @managers = Manager.page(page).per(page_size)
    end
    respond_to do |format|
      format.json { render json: @managers }
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
    if params[:updated_at]
      @warehouses = Warehouse.where("updated_at >= ?", params[:updated_at]).page(page).per(page_size)
    else
      @warehouses = Warehouse.page(page).per(page_size)
    end 
    respond_to do |format|
      format.json { render json: @warehouses }
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
        format.html # index.html.erb
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
        format.html # index.html.erb
        format.json { render json: @template_route_points }
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
  end
  
  # POST /orders.json
  def orders
    @manager_id = current_user.manager_id
    @order = Order.find_by_shipping_address_id_and_manager_id_and_date(params[:order][:shipping_address_id], @manager_id, params[:order][:date])
    if @order      
      respond_to do |format|
        @responce = JSON code: 102, description: 'already exists'
        format.json { render json: @responce, status: :ok, location: @order }
      end
    else
      params[:order][:manager_id] = @manager_id
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
  end    
end