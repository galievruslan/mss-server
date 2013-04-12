class PriceListLinesController < ApplicationController
  # GET /price_list_lines
  # GET /price_list_lines.json
  def index
    @price_list = PriceList.find(params[:price_list_id])
    @search = @price_list.product_prices.search(params[:q])
    @price_list_lines = @search.result.page(params[:page]).per(current_user.list_page_size)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @price_list_lines }
    end
  end

  # GET /price_list_lines/1
  # GET /price_list_lines/1.json
  def show
    @price_list = PriceList.find(params[:price_list_id])
    @price_list_line = ProductPrice.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @price_list_line }
    end
  end

  # GET /price_list_lines/new
  # GET /price_list_lines/new.json
  def new
    @products = Product.where(validity: true)
    @price_list = PriceList.find(params[:price_list_id])
    @price_list_line = ProductPrice.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @price_list_line }
    end
  end

  # GET /price_list_lines/1/edit
  def edit
    @products = Product.where(validity: true)
    @price_list = PriceList.find(params[:price_list_id])
    @price_list_line = ProductPrice.find(params[:id])
  end

  # POST /price_list_lines
  # POST /price_list_lines.json
  def create
    @products = Product.where(validity: true)
    @price_list = PriceList.find(params[:price_list_id])    
    @price_list_line = ProductPrice.new(params[:product_price])
    @price_list.product_prices << @price_list_line
    @price_list.save

    respond_to do |format|
      if @price_list_line.save
        format.html { redirect_to price_list_price_list_line_path(@price_list, @price_list_line), notice: t(:product_price_created) }
        format.json { render json: @price_list_line, status: :created, location: @price_list_line }
      else
        format.html { render action: "new" }
        format.json { render json: @price_list_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /price_list_lines/1
  # PUT /price_list_lines/1.json
  def update
    @products = Product.where(validity: true)
    @price_list = PriceList.find(params[:price_list_id])
    @price_list_line = ProductPrice.find(params[:id])

    respond_to do |format|
      if @price_list_line.update_attributes(params[:product_price])
        format.html { redirect_to price_list_price_list_line_path(@price_list, @price_list_line), notice: t(:product_price_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @price_list_line.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /price_list_lines/1
  # DELETE /price_list_lines/1.json
  def destroy
    @price_list = PriceList.find(params[:price_list_id])
    @price_list_line = ProductPrice.find(params[:id])
    @price_list_line.destroy

    respond_to do |format|
      format.html { redirect_to price_list_price_list_lines_path(@price_list), notice: t(:product_price_destroyed) }
      format.json { head :no_content }
    end
  end
end
