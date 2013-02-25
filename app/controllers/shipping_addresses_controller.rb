class ShippingAddressesController < ApplicationController
  load_and_authorize_resource
  # GET /shipping_addresses
  # GET /shipping_addresses.json
  def index
    @customer = Customer.find(params[:customer_id])
    @search = @customer.shipping_addresses.search(params[:q])
    @shipping_addresses = @search.result.page(params[:page]).per(current_user.list_page_size)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @shipping_addresses }
    end
  end

  # GET /shipping_addresses/1
  # GET /shipping_addresses/1.json
  def show
    @customer = Customer.find(params[:customer_id])
    @shipping_address = ShippingAddress.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @shipping_address }
    end
  end

  # GET /shipping_addresses/new
  # GET /shipping_addresses/new.json
  def new
    @customer = Customer.find(params[:customer_id])
    @shipping_address = ShippingAddress.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @shipping_address }
    end
  end

  # GET /shipping_addresses/1/edit
  def edit
    @customer = Customer.find(params[:customer_id])
    @shipping_address = ShippingAddress.find(params[:id])
  end

  # POST /shipping_addresses
  # POST /shipping_addresses.json
  def create
    @customer = Customer.find(params[:customer_id])
    @shipping_address = ShippingAddress.new(params[:shipping_address])
    @customer.shipping_addresses << @shipping_address
    @customer.save 
    respond_to do |format|
      if @shipping_address.save
        format.html { redirect_to customer_shipping_address_path(@customer, @shipping_address), notice: 'Shipping address was successfully created.' }
        format.json { render json: @shipping_address, status: :created, location: @shipping_address }
      else
        format.html { render action: "new" }
        format.json { render json: @shipping_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /shipping_addresses/1
  # PUT /shipping_addresses/1.json
  def update
    @customer = Customer.find(params[:customer_id])
    @shipping_address = ShippingAddress.find(params[:id])

    respond_to do |format|
      if @shipping_address.update_attributes(params[:shipping_address])
        format.html { redirect_to customer_shipping_address_path(@customer, @shipping_address), notice: 'Shipping address was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @shipping_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shipping_addresses/1
  # DELETE /shipping_addresses/1.json
  def destroy
    @customer = Customer.find(params[:customer_id])
    @shipping_address = ShippingAddress.find(params[:id])
    if @shipping_address.validity
      @shipping_address.update_attributes(validity: false)
    else
      @shipping_address.update_attributes(validity: true)
    end  

    respond_to do |format|
      format.html { redirect_to customer_shipping_addresses_path(@customer) }
      format.json { head :no_content }
    end
  end
end
