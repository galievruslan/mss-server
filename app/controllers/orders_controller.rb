class OrdersController < ApplicationController
  load_and_authorize_resource
  # GET /orders
  # GET /orders.json
  def index
    @search = Order.search(params[:q])
    @orders = @search.result.page(params[:page]).per(current_user.list_page_size)
    @managers = Manager.all
    @warehouses = Warehouse.all
    @price_lists = PriceList.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @orders }
      format.xml # index.xml.erb
    end
  end

  # GET /orders/1
  # GET /orders/1.json
  def show
    @order = Order.find(params[:id])
    @search = @order.order_items.search(params[:q])
    @order_items = @search.result.page(params[:page]).per(current_user.list_page_size)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/new
  # GET /orders/new.json
  def new
    @customers = Customer.where(validity: true)    
    if current_user.manager_id
      @managers = Manager.where(id: current_user.manager_id)
    else
      @managers = Manager.where(validity: true)
    end
    @price_lists = PriceList.where(validity: true)
    @warehouses = Warehouse.where(validity: true)
    @products = Product.where(validity: true)
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @order = Order.find(params[:id])    
    @select_customer = @order.shipping_address.customer
    @select_customer_id = @select_customer.id
    @select_shipping_address_id = @order.shipping_address.id
    @shipping_addresses = @select_customer.shipping_addresses
    @customers = Customer.where(validity: true)    
    if current_user.manager_id
      @managers = Manager.where(id: current_user.manager_id)
    else
      @managers = Manager.where(validity: true)
    end
    @price_lists = PriceList.where(validity: true)
    @warehouses = Warehouse.where(validity: true)
    @products = Product.where(validity: true)
    @unit_of_measures = UnitOfMeasure.where(validity: true)    
  end

  # POST /orders
  # POST /orders.json
  def create
    @customers = Customer.where(validity: true)
    if params[:customer_id] != ""
      @select_customer_id = params[:customer_id]
      @shipping_addresses = Customer.find(params[:customer_id]).shipping_addresses
    end
    if params[:order][:shipping_address_id] !=""
      @select_shipping_address_id = params[:order][:shipping_address_id]
    end
    if current_user.manager_id
      @managers = Manager.where(id: current_user.manager_id)
    else
      @managers = Manager.where(validity: true)
    end
    @price_lists = PriceList.where(validity: true)
    @warehouses = Warehouse.where(validity: true)
    @products = Product.where(validity: true)
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: t(:order_created) }
        format.json { render json: @order, status: :created, location: @order }
      else
        format.html { render action: "new" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /orders/1
  # PUT /orders/1.json
  def update
    @order = Order.find(params[:id]) 
    
    if params[:customer_id] != ""
      @select_customer_id = params[:customer_id]
      @shipping_addresses = Customer.find(params[:customer_id]).shipping_addresses
    else
      @select_customer = @order.shipping_address.customer
      @select_customer_id = @select_customer.id
      @shipping_addresses = @select_customer.shipping_addresses
    end
    if params[:order][:shipping_address_id] !=""
      @select_shipping_address_id = params[:order][:shipping_address_id]
    end    
    
    @customers = Customer.where(validity: true)    
    if current_user.manager_id
      @managers = Manager.where(id: current_user.manager_id)
    else
      @managers = Manager.where(validity: true)
    end
    @price_lists = PriceList.where(validity: true)
    @warehouses = Warehouse.where(validity: true)
    @products = Product.where(validity: true)
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    
    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: t(:order_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /orders/1
  # DELETE /orders/1.json
  def destroy
    @order = Order.find(params[:id])
    @order.destroy

    respond_to do |format|
      format.html { redirect_to orders_url, notice: t(:order_destroyed)}
      format.json { head :no_content }
    end
  end
  
  # GET /orders/generate_xml
  def generate_xml
    data = Builder::XmlMarkup.new( :target => out_data = "", :indent => 2 )
    data.instruct!
    order = Order.find(params[:id])        
    data.order do        
      data.id(order.id)
      data.date(order.date)
      data.shipping_date(order.shipping_date)
      data.customer_id(order.shipping_address.customer.id)
      data.customer_name(order.shipping_address.customer.name)
      data.customer_external_key(order.shipping_address.customer.external_key)
      data.shipping_address_id(order.shipping_address.id)
      data.shipping_address_external_key(order.shipping_address.external_key)
      data.shipping_address_name(order.shipping_address.name)
      data.manager_id(order.manager.id)
      data.manager_name(order.manager.name)
      data.manager_external_key(order.manager.external_key)
      data.warehouse_id(order.warehouse.id)
      data.warehouse_name(order.warehouse.name)
      data.warehouse_external_key(order.warehouse.external_key)
      data.price_list_id(order.price_list.id)
      data.price_list_name(order.price_list.name)
      data.price_list_external_key(order.price_list.external_key)
      data.order_items do
        order.order_items.each do |order_item|
          data.order_item do
            data.product_id(order_item.product.id)
            data.product_external_key(order_item.product.external_key)
            data.product_name(order_item.product.name)
            data.unit_of_measure_name(order_item.unit_of_measure.name)
            data.unit_of_measure_external_key(order_item.unit_of_measure.external_key)
            data.quantity(order_item.quantity)
          end
        end
      end  
    end    
    send_data( out_data, :type => "text/xml", :filename => "order-#{order.id}-#{order.date}.xml" )  
  end
  
  # GET /orders/export_again
  def export_again
    @order = Order.find(params[:id])
    @order.update_attributes(exported_at: nil)    
    
    respond_to do |format|
        format.html { redirect_to orders_path, notice: t(:order_export_again) }
        format.json { head :no_content }      
    end
  end
  
  def update_shipping_addresses
    @shipping_addresses = ShippingAddress.where(customer_id: params[:customer_id]) 
    render :partial => "shipping_addresses", :object => @shipping_addresses  
  end
  
  # POST /orders/multiple_change
  def multiple_change
    if params[:order_ids]
      if params[:button]=='export_again'
        params[:order_ids].each do |order_id|
          @order = Order.find(order_id)        
          @order.update_attributes(exported_at: nil)        
        end
        redirect_to orders_url, notice: t(:orders_export_again)
      elsif params[:button]=='remove'
        params[:order_ids].each do |order_id|
          @order = Order.find(order_id)        
          @order.destroy
        end
        redirect_to orders_url, notice: t(:orders_removed)
      end      
    else
      redirect_to orders_url
    end  
  end  
end
