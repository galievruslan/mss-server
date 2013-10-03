class WarehousesController < ApplicationController
  load_and_authorize_resource
  # GET /warehouses
  # GET /warehouses.json
  def index
    if params[:q]
      @search = Warehouse.search(params[:q])
      @warehouses = @search.result.page(params[:page]).per(current_user.list_page_size)    
    else
      @search = Warehouse.search(params[:q])    
      @warehouses = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @warehouses }
    end
  end

  # GET /warehouses/1
  # GET /warehouses/1.json
  def show
    @warehouse = Warehouse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @warehouse }
    end
  end

  # GET /warehouses/new
  # GET /warehouses/new.json
  def new
    @warehouse = Warehouse.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @warehouse }
    end
  end

  # GET /warehouses/1/edit
  def edit
    @warehouse = Warehouse.find(params[:id])
  end

  # POST /warehouses
  # POST /warehouses.json
  def create
    @warehouse = Warehouse.new(params[:warehouse])

    respond_to do |format|
      if @warehouse.save
        format.html { redirect_to @warehouse, notice: t(:warehouse_created) }
        format.json { render json: @warehouse, status: :created, location: @warehouse }
      else
        format.html { render action: "new" }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /warehouses/1
  # PUT /warehouses/1.json
  def update
    @warehouse = Warehouse.find(params[:id])

    respond_to do |format|
      if @warehouse.update_attributes(params[:warehouse])
        format.html { redirect_to @warehouse, notice: t(:warehouse_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /warehouses/1
  # DELETE /warehouses/1.json
  def destroy
    @warehouse = Warehouse.find(params[:id])
    if @warehouse.validity
      @warehouse.update_attributes(validity: false)
      @manager_warehouses = ManagerWarehouse.where(warehouse_id: params[:id])
      @manager_warehouses.each { |x| x.update_attributes(validity: false)}
    else
      @warehouse.update_attributes(validity: true)
    end
        
    respond_to do |format|
      format.html { redirect_to warehouses_url, notice: t(:validity_changed) }
      format.json { head :no_content }
    end
  end
  
    # POST /warehouses/multiple_change
  def multiple_change
    if params[:warehouse_ids]
      params[:warehouse_ids].each do |warehouse_id|
        @warehouse = Warehouse.find(warehouse_id)
        if @warehouse.validity
          @warehouse.update_attributes(validity: false)
          @manager_warehouses = ManagerWarehouse.where(warehouse_id: warehouse_id)
          @manager_warehouses.each { |x| x.update_attributes(validity: false)}
        else
          @warehouse.update_attributes(validity: true)
        end
      end
      redirect_to warehouses_url, notice: t(:validity_changed)
    else
      redirect_to warehouses_url
    end
  end
end
