class ManagerShippingAddressesController < ApplicationController
  # GET /manager_shipping_addresses
  # GET /manager_shipping_addresses.json
  def index
    @manager_shipping_addresses = ManagerShippingAddress.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @manager_shipping_addresses }
    end
  end

  # GET /manager_shipping_addresses/1
  # GET /manager_shipping_addresses/1.json
  def show
    @manager_shipping_address = ManagerShippingAddress.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manager_shipping_address }
    end
  end

  # GET /manager_shipping_addresses/new
  # GET /manager_shipping_addresses/new.json
  def new
    @manager_shipping_address = ManagerShippingAddress.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manager_shipping_address }
    end
  end

  # GET /manager_shipping_addresses/1/edit
  def edit
    @manager_shipping_address = ManagerShippingAddress.find(params[:id])
  end

  # POST /manager_shipping_addresses
  # POST /manager_shipping_addresses.json
  def create
    @manager_shipping_address = ManagerShippingAddress.new(params[:manager_shipping_address])

    respond_to do |format|
      if @manager_shipping_address.save
        format.html { redirect_to @manager_shipping_address, notice: 'Manager shipping address was successfully created.' }
        format.json { render json: @manager_shipping_address, status: :created, location: @manager_shipping_address }
      else
        format.html { render action: "new" }
        format.json { render json: @manager_shipping_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manager_shipping_addresses/1
  # PUT /manager_shipping_addresses/1.json
  def update
    @manager_shipping_address = ManagerShippingAddress.find(params[:id])

    respond_to do |format|
      if @manager_shipping_address.update_attributes(params[:manager_shipping_address])
        format.html { redirect_to @manager_shipping_address, notice: 'Manager shipping address was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manager_shipping_address.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /manager_shipping_addresses/1
  # DELETE /manager_shipping_addresses/1.json
  def destroy
    @manager_shipping_address = ManagerShippingAddress.find(params[:id])
    @manager_shipping_address.destroy

    respond_to do |format|
      format.html { redirect_to manager_shipping_addresses_url }
      format.json { head :no_content }
    end
  end
end
