class ProductUnitOfMeasuresController < ApplicationController
  load_and_authorize_resource
  # GET /product_unit_of_measures
  # GET /product_unit_of_measures.json
  def index
    @product = Product.find(params[:product_id])
    @search = @product.product_unit_of_measures.search(params[:q])
    @product_unit_of_measures = @search.result.page(params[:page])
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
    @unit_of_measures = UnitOfMeasure.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product_unit_of_measure }
    end
  end

  # GET /product_unit_of_measures/1/edit
  def edit    
    @unit_of_measures = UnitOfMeasure.all
    @product = Product.find(params[:product_id])
    @product_unit_of_measure = ProductUnitOfMeasure.find(params[:id])
  end

  # POST /product_unit_of_measures
  # POST /product_unit_of_measures.json
  def create
    @unit_of_measures = UnitOfMeasure.all
    @product = Product.find(params[:product_id])
    @product_unit_of_measure = ProductUnitOfMeasure.new(params[:product_unit_of_measure])
    @product.product_unit_of_measures << @product_unit_of_measure
    @product.save
    
    respond_to do |format|
      if @product_unit_of_measure.save
        format.html { redirect_to product_product_unit_of_measure_path(@product, @product_unit_of_measure), notice: 'Product unit of measure was successfully created.' }
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
    @unit_of_measures = UnitOfMeasure.all
    @product = Product.find(params[:product_id])
    @product_unit_of_measure = ProductUnitOfMeasure.find(params[:id])

    respond_to do |format|
      if @product_unit_of_measure.update_attributes(params[:product_unit_of_measure])
        format.html { redirect_to product_product_unit_of_measure_path(@product, @product_unit_of_measure), notice: 'Product unit of measure was successfully updated.' }
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
    @product_unit_of_measure.destroy

    respond_to do |format|
      format.html { redirect_to product_product_unit_of_measures_path(@product), notice: 'Product unit of measure was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
