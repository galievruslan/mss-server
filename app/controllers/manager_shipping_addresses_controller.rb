class ManagerShippingAddressesController < ApplicationController
  # GET /manager_shipping_addresses
  # GET /manager_shipping_addresses.json
  def index
    @manager = Manager.find(params[:manager_id])
    
    if params[:q]
      @search = @manager.manager_shipping_addresses.search(params[:q])
      @manager_shipping_addresses = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = @manager.manager_shipping_addresses.search(params[:q])
      @manager_shipping_addresses = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @manager_shipping_addresses }
    end
  end

  # GET /manager_shipping_addresses/1
  # GET /manager_shipping_addresses/1.json
  def show
    @manager = Manager.find(params[:manager_id])
    @manager_shipping_address = ManagerShippingAddress.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manager_shipping_address }
    end
  end

  # GET /manager_shipping_addresses/new
  # GET /manager_shipping_addresses/new.json
  def new
    @shipping_addresses = ShippingAddress.where(validity: true)
    @manager = Manager.find(params[:manager_id])
    @manager_shipping_address = ManagerShippingAddress.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manager_shipping_address }
    end
  end

  # GET /manager_shipping_addresses/1/edit
  def edit
    @shipping_addresses = ShippingAddress.where(validity: true)
    @manager = Manager.find(params[:manager_id])
    @manager_shipping_address = ManagerShippingAddress.find(params[:id])
  end

  # POST /manager_shipping_addresses
  # POST /manager_shipping_addresses.json
  def create
    @shipping_addresses = ShippingAddress.where(validity: true)
    @manager = Manager.find(params[:manager_id])
    @manager_shipping_address = ManagerShippingAddress.new(params[:manager_shipping_address])
    @manager.manager_shipping_addresses << @manager_shipping_address
    @manager.save
    respond_to do |format|
      if @manager_shipping_address.save
        format.html { redirect_to manager_manager_shipping_addresses_path(@manager), notice: t(:manager_shipping_address_created) }
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
    @manager = Manager.find(params[:manager_id])
    @manager_shipping_address = ManagerShippingAddress.find(params[:id])

    respond_to do |format|
      if @manager_shipping_address.update_attributes(params[:manager_shipping_address])
        format.html { redirect_to manager_manager_shipping_addresses_path(@manager), notice: t(:manager_shipping_address_updated) }
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
    @manager = Manager.find(params[:manager_id])
    @manager_shipping_address = ManagerShippingAddress.find(params[:id]) 
       
    if @manager_shipping_address.validity 
      @manager_shipping_address.update_attributes(validity: false)
    else
      @manager_shipping_address.update_attributes(validity: true)
    end

    respond_to do |format|
      format.html { redirect_to manager_manager_shipping_addresses_path(@manager) }
      format.json { head :no_content }
    end
  end
end
