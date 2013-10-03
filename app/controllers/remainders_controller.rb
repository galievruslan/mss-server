class RemaindersController < ApplicationController
  # GET /remainders
  # GET /remainders.json
  def index    
    @products = Product.all
    @warehouses = Warehouse.all
    @unit_of_measures = UnitOfMeasure.all
    @search = Remainder.search(params[:q])
    @remainders = @search.result.page(params[:page]).per(current_user.list_page_size)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @remainders }
    end
  end

  # GET /remainders/1
  # GET /remainders/1.json
  def show
    @remainder = Remainder.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @remainder }
    end
  end

  # GET /remainders/new
  # GET /remainders/new.json
  def new
    @products = Product.where(validity: true)
    @warehouses = Warehouse.where(validity: true)
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @remainder = Remainder.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @remainder }
    end
  end

  # GET /remainders/1/edit
  def edit
    @products = Product.where(validity: true)
    @warehouses = Warehouse.where(validity: true)
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @remainder = Remainder.find(params[:id])
  end

  # POST /remainders
  # POST /remainders.json
  def create
    @products = Product.where(validity: true)
    @warehouses = Warehouse.where(validity: true)
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @remainder = Remainder.new(params[:remainder])

    respond_to do |format|
      if @remainder.save
        format.html { redirect_to @remainder, notice: t(:remainder_created) }
        format.json { render json: @remainder, status: :created, location: @remainder }
      else
        format.html { render action: "new" }
        format.json { render json: @remainder.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /remainders/1
  # PUT /remainders/1.json
  def update
    @products = Product.where(validity: true)
    @warehouses = Warehouse.where(validity: true)
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @remainder = Remainder.find(params[:id])

    respond_to do |format|
      if @remainder.update_attributes(params[:remainder])
        format.html { redirect_to @remainder, notice: t(:remainder_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @remainder.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /remainders/1
  # DELETE /remainders/1.json
  def destroy
    @remainder = Remainder.find(params[:id])
    @remainder.destroy

    respond_to do |format|
      format.html { redirect_to remainders_url, notice: t(:remainder_destroyed) }
      format.json { head :no_content }
    end
  end
  
  # POST /remainders/multiple_change
  def multiple_change
    if params[:remainder_ids]
      params[:remainder_ids].each do |remainder_id|
        @remainder = Remainder.find(remainder_id)
        @remainder.destroy
      end
      redirect_to remainders_url, notice: t(:remainder_destroyed)
    else
      redirect_to remainders_url
    end
  end
end
