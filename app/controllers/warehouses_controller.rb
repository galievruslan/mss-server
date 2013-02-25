class WarehousesController < ApplicationController
  load_and_authorize_resource
  # GET /warehouses
  # GET /warehouses.json
  def index
    @search = Warehouse.search(params[:q])
    @warehouses = @search.result.page(params[:page])
    
    if params[:updated_at]
      @warehouses_json = Warehouse.where("updated_at >= #{params[:updated_at]}")
    else
      @warehouses_json = Warehouse.all
    end 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @warehouses_json }
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
        format.html { redirect_to @warehouse, notice: 'Warehouse was successfully created.' }
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
        format.html { redirect_to @warehouse, notice: 'Warehouse was successfully updated.' }
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
    else
      @warehouse.update_attributes(validity: true)
    end
        
    respond_to do |format|
      format.html { redirect_to warehouses_url }
      format.json { head :no_content }
    end
  end
end
