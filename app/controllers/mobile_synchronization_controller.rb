class MobileSynchronizationController < ApplicationController
  
  include MobileSynchronizationHelper
  
  # GET /customers.json
  def customers    
    if params[:updated_at]
      @customers = Customer.where("updated_at >= #{params[:updated_at]}").page(page).per(page_size).includes(:shipping_addresses)
    else
      @customers = Customer.page(page).per(page_size).includes(:shipping_addresses)
    end
    respond_to do |format|
      format.json { render json: @customers.to_json(:include => [:shipping_addresses]) }
    end 
  end 
  
  # GET /managers.json
  def managers
    if params[:updated_at]
      @managers = Manager.where("updated_at >= #{params[:updated_at]}").page(page).per(page_size).includes(:shipping_addresses)
    else
      @managers = Manager.page(page).per(page_size).includes(:manager_shipping_addresses)
    end
    respond_to do |format|
      format.json { render json: @managers.to_json(:include => [:manager_shipping_addresses]) }
    end 
  end
  
  # GET /categories.json
  def categories
    if params[:updated_at]
      @categories = Category.where("updated_at >= #{params[:updated_at]}").page(page).per(page_size)
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
      @products = Product.where("updated_at >= #{params[:updated_at]}").page(page).per(page_size).includes(:product_unit_of_measures, :product_prices)
    else
      @products = Product.page(page).per(page_size).includes(:product_unit_of_measures, :product_prices)
    end 
    respond_to do |format|
      format.json { render json: @products.to_json(:include => [:product_unit_of_measures, :product_prices]) }
    end 
  end
  
  # GET /warehouses.json
  def warehouses
    if params[:updated_at]
      @warehouses = Warehouse.where("updated_at >= #{params[:updated_at]}").page(page).per(page_size)
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
      @statuses = Status.where("updated_at >= #{params[:updated_at]}").page(page).per(page_size)
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
      @price_lists = PriceList.where("updated_at >= #{params[:updated_at]}").page(page).per(page_size)
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
      @unit_of_measures = UnitOfMeasure.where("updated_at >= #{params[:updated_at]}").page(page).per(page_size)
    else
      @unit_of_measures = UnitOfMeasure.page(page).per(page_size)
    end 
    respond_to do |format|
      format.json { render json: @unit_of_measures }
    end 
  end
  
  # GET /template_routes.json
  def template_routes
    if params[:updated_at]
      if params[:manager_id]
        @template_routes = TemplateRoute.where("updated_at >= #{params[:updated_at]} and manager_id = #{params[:manager_id]}").page(page).per(page_size).includes(:template_route_points)
      else
        @template_routes = TemplateRoute.where("updated_at >= #{params[:updated_at]}").page(page).per(page_size).includes(:template_route_points)
      end      
    else
      if params[:manager_id]
        @template_routes = TemplateRoute.where("manager_id = #{params[:manager_id]}").page(page).per(page_size).includes(:template_route_points)
      else
        @template_routes = TemplateRoute.page(page).per(page_size).includes(:template_route_points)
      end      
    end 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @template_routes.to_json(:include => [:template_route_points]) }
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
