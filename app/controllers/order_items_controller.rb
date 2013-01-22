class OrderItemsController < ApplicationController
  load_and_authorize_resource
  # GET /order_items
  # GET /order_items.json
  def index    
    @order = Order.find(params[:order_id])
    @order_items = @order.order_items
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @order_items }
    end
  end

  # GET /order_items/1
  # GET /order_items/1.json
  def show    
    @order = Order.find(params[:order_id])
    @order_item = OrderItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @order_item }
    end
  end

  # GET /order_items/new
  # GET /order_items/new.json
  def new
    @products = Product.all
    @order = Order.find(params[:order_id])
    @order_item = OrderItem.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @order_item }
    end
  end

  # GET /order_items/1/edit
  def edit
    @products = Product.all
    @order = Order.find(params[:order_id])
    @order_item = OrderItem.find(params[:id])
  end

  # POST /order_items
  # POST /order_items.json
  def create
    @products = Product.all
    @order = Order.find(params[:order_id])
    @order_item = OrderItem.new(params[:order_item])
    @order.order_items << @order_item
    @order.save

    respond_to do |format|
      if @order_item.save
        format.html { redirect_to order_order_item_path(@order, @order_item), notice: 'Order item was successfully created.' }
        format.json { render json: @order_item, status: :created, location: @order_item }
      else
        format.html { render action: "new" }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /order_items/1
  # PUT /order_items/1.json
  def update
    @products = Product.all
    @order = Order.find(params[:order_id])
    @order_item = OrderItem.find(params[:id])

    respond_to do |format|
      if @order_item.update_attributes(params[:order_item])
        format.html { redirect_to order_order_item_path(@order, @order_item), notice: 'Order item was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @order_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /order_items/1
  # DELETE /order_items/1.json
  def destroy
    @order = Order.find(params[:order_id])
    @order_item = OrderItem.find(params[:id])
    @order_item.destroy

    respond_to do |format|
      format.html { redirect_to order_order_items_path(@order) }
      format.json { head :no_content }
    end
  end
end
