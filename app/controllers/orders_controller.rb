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
    @shipping_addresses = ShippingAddress.all
    @managers = Manager.all
    @price_lists = PriceList.all
    @warehouses = Warehouse.all
    @order = Order.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order }
    end
  end

  # GET /orders/1/edit
  def edit
    @shipping_addresses = ShippingAddress.all
    @managers = Manager.all
    @price_lists = PriceList.all
    @warehouses = Warehouse.all
    @order = Order.find(params[:id])
  end

  # POST /orders
  # POST /orders.json
  def create
    @shipping_addresses = ShippingAddress.all
    @managers = Manager.all
    @price_lists = PriceList.all
    @warehouses = Warehouse.all
    @order = Order.new(params[:order])

    respond_to do |format|
      if @order.save
        format.html { redirect_to @order, notice: 'Order was successfully created.' }
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

    respond_to do |format|
      if @order.update_attributes(params[:order])
        format.html { redirect_to @order, notice: 'Order was successfully updated.' }
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
      format.html { redirect_to orders_url }
      format.json { head :no_content }
    end
  end
  
  def generate_xml
    data = Builder::XmlMarkup.new( :target => out_data = "", :indent => 2 )
    data.instruct!
    @orders = Order.all        
    data.orders do
      @orders.each do |order|
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
          data.order_items do
            order.order_items.each do |order_item|
              data.order_item do
                data.product_id(order_item.product.id)
                data.product_external_key(order_item.product.external_key)
                data.product_name(order_item.product.name)
                data.quantity(order_item.quantity)
              end
            end
          end
        end
      end  
    end    
    send_data( out_data, :type => "text/xml", :filename => "orders.xml" )  
  end
  
  def export_again
    @order = Order.find(params[:id])
    @order.update_attributes(exported_at: nil)    
    
    respond_to do |format|
        format.html { redirect_to orders_path, notice: "Order exported datetime removed." }
        format.json { head :no_content }      
    end
  end  
end
