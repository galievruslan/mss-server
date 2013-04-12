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
    @shipping_addresses = ShippingAddress.where(validity: true)
    @managers = Manager.where(validity: true)
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
    @shipping_addresses = ShippingAddress.where(validity: true)
    @managers = Manager.where(validity: true)
    @price_lists = PriceList.where(validity: true)
    @warehouses = Warehouse.where(validity: true)
    @products = Product.where(validity: true)
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @shipping_addresses = ShippingAddress.where(validity: true)
    @managers = Manager.where(validity: true)
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
    if params[:external_key]
      @order = Order.find_by_external_key(params[:external_key])
    else
      @order = Order.find(params[:id])
    end
    
    @shipping_addresses = ShippingAddress.where(validity: true)
    @managers = Manager.where(validity: true)
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
  
  def generate_xml
    data = Builder::XmlMarkup.new( :target => out_data = "", :indent => 2 )
    data.instruct!
    order = Order.find(params[:id])        
    data.order do        
      data.id(order.id)
      data.date(order.date)
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
  
  def export_again
    @order = Order.find(params[:id])
    @order.update_attributes(exported_at: nil)    
    
    respond_to do |format|
        format.html { redirect_to orders_path, notice: t(:order_export_again) }
        format.json { head :no_content }      
    end
  end  
end
