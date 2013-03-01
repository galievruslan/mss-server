class ProductPricesController < ApplicationController
  # GET /product_prices
  # GET /product_prices.json
  def index
    @product = Product.find(params[:product_id])
    @search = @product.product_prices.search(params[:q])
    @product_prices = @search.result.page(params[:page]).per(current_user.list_page_size)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @product_prices }
    end
  end

  # GET /product_prices/1
  # GET /product_prices/1.json
  def show
    @product = Product.find(params[:product_id])
    @product_price = ProductPrice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product_price }
    end
  end

  # GET /product_prices/new
  # GET /product_prices/new.json
  def new
    @price_lists = PriceList.all
    @product = Product.find(params[:product_id])
    @product_price = ProductPrice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product_price }
    end
  end

  # GET /product_prices/1/edit
  def edit
    @price_lists = PriceList.all
    @product = Product.find(params[:product_id])
    @product_price = ProductPrice.find(params[:id])
  end

  # POST /product_prices
  # POST /product_prices.json
  def create
    @price_lists = PriceList.all
    @product = Product.find(params[:product_id])     
    @product_price = ProductPrice.new(params[:product_price])
    @product.product_prices << @product_price
    @product.save

    respond_to do |format|
      if @product_price.save
        format.html { redirect_to product_product_price_path(@product, @product_price), notice: t(:product_price_created) }
        format.json { render json: @product_price, status: :created, location: @product_price }
      else
        format.html { render action: "new" }
        format.json { render json: @product_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_prices/1
  # PUT /product_prices/1.json
  def update
    @price_lists = PriceList.all
    @product = Product.find(params[:product_id])
    @product_price = ProductPrice.find(params[:id])

    respond_to do |format|
      if @product_price.update_attributes(params[:product_price])
        format.html { redirect_to product_product_price_path(@product, @product_price), notice: t(:product_price_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product_price.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /product_prices/1
  # DELETE /product_prices/1.json
  def destroy
    @product = Product.find(params[:product_id])
    @product_price = ProductPrice.find(params[:id])
    @product_price.destroy

    respond_to do |format|
      format.html { redirect_to product_product_prices_path(@product), notice: t(:product_price_destroyed) }
      format.json { head :no_content }
    end
  end
end
