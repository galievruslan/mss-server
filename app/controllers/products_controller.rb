class ProductsController < ApplicationController
  load_and_authorize_resource
  # GET /products
  # GET /products.json
  def index
    @search = Product.search(params[:q])
    @products = @search.result.page(params[:page]).per(current_user.list_page_size)
    @categories = Category.all
    
    if params[:page_size]
      page_size = params[:page_size]
    else
      page_size = 100
    end
    
    if params[:updated_at]
      @products_json = Product.where("updated_at >= #{params[:updated_at]}").page(params[:page]).per(page_size).includes(:product_unit_of_measures)
    else
      @products_json = Product.page(params[:page]).per(page_size).includes(:product_unit_of_measures, :product_prices)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products_json.to_json(:include => [:product_unit_of_measures, :product_prices]) }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @categories = Category.all
    @product = Product.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @categories = Category.all
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: t(:product_created) }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: t(:product_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /products/1
  # DELETE /products/1.json
  def destroy
    @product = Product.find(params[:id])
    if @product.validity
      @product.update_attributes(validity: false)
    else
      @product.update_attributes(validity: true)
    end
    
    respond_to do |format|
      format.html { redirect_to products_url }
      format.json { head :no_content }
    end
  end
end
