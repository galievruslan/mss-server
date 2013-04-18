class ProductUnitOfMeasuresController < ApplicationController
  load_and_authorize_resource
  # GET /product_unit_of_measures
  # GET /product_unit_of_measures.json
  def index
    @product = Product.find(params[:product_id])
    if params[:q]
      @search = @product.product_unit_of_measures.search(params[:q])
      @product_unit_of_measures = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = @product.product_unit_of_measures.search(params[:q])
      @product_unit_of_measures = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end
    
    @unit_of_measures = UnitOfMeasure.all
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @product_unit_of_measures }
    end
  end

  # GET /product_unit_of_measures/1
  # GET /product_unit_of_measures/1.json
  def show
    @product = Product.find(params[:product_id])
    @product_unit_of_measure = ProductUnitOfMeasure.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product_unit_of_measure }
    end
  end

  # GET /product_unit_of_measures/new
  # GET /product_unit_of_measures/new.json
  def new
    @product = Product.find(params[:product_id])    
    @product_unit_of_measure = ProductUnitOfMeasure.new
    @unit_of_measures = UnitOfMeasure.where(validity: true)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product_unit_of_measure }
    end
  end

  # GET /product_unit_of_measures/1/edit
  def edit    
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @product = Product.find(params[:product_id])
    @product_unit_of_measure = ProductUnitOfMeasure.find(params[:id])
  end

  # POST /product_unit_of_measures
  # POST /product_unit_of_measures.json
  def create
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @product = Product.find(params[:product_id])
    @product_unit_of_measure = ProductUnitOfMeasure.new(params[:product_unit_of_measure])
    @product.product_unit_of_measures << @product_unit_of_measure
    @product.save
    
    respond_to do |format|
      if @product_unit_of_measure.save
        format.html { redirect_to product_product_unit_of_measure_path(@product, @product_unit_of_measure), notice: t(:product_unit_of_measure_created) }
        format.json { render json: @product_unit_of_measure, status: :created, location: @product_unit_of_measure }
      else
        format.html { render action: "new" }
        format.json { render json: @product_unit_of_measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_unit_of_measures/1
  # PUT /product_unit_of_measures/1.json
  def update
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @product = Product.find(params[:product_id])
    @product_unit_of_measure = ProductUnitOfMeasure.find(params[:id])

    respond_to do |format|
      if @product_unit_of_measure.update_attributes(params[:product_unit_of_measure])
        format.html { redirect_to product_product_unit_of_measure_path(@product, @product_unit_of_measure), notice: t(:product_unit_of_measure_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product_unit_of_measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_unit_of_measures/1
  # DELETE /product_unit_of_measures/1.json
  def destroy
    @product = Product.find(params[:product_id])
    @product_unit_of_measure = ProductUnitOfMeasure.find(params[:id])
    if @product_unit_of_measure.validity
      @product_unit_of_measure.update_attributes(validity: false)
    else
      @product_unit_of_measure.update_attributes(validity: true)
    end

    respond_to do |format|
      format.html { redirect_to product_product_unit_of_measures_path(@product), notice: t(:validity_changed) }
      format.json { head :no_content }
    end
  end
  
    # POST /product/1/product_unit_of_measures/multiple_change_validity
  def multiple_change_validity
    @product = Product.find(params[:product_id])
    params[:product_unit_of_measure_ids].each do |product_unit_of_measure_id|
      @product_unit_of_measure = ProductUnitOfMeasure.find(product_unit_of_measure_id)
      if @product_unit_of_measure.validity
        @product_unit_of_measure.update_attributes(validity: false)
      else
        @product_unit_of_measure.update_attributes(validity: true)
      end
    end
    respond_to do |format|
      format.html { redirect_to product_product_unit_of_measures_path(@product), notice: t(:validity_changed)  }
      format.json { head :no_content }
    end
  end
end
