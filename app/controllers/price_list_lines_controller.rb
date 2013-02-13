class PriceListLinesController < ApplicationController
  # GET /price_list_lines
  # GET /price_list_lines.json
  def index
    @price_list = PriceList.find(params[:price_list_id])
    @search = @price_list.price_list_lines.search(params[:q])
    @price_list_lines = @search.result.page(params[:page])

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @price_list_lines }
    end
  end

  # GET /price_list_lines/1
  # GET /price_list_lines/1.json
  def show
    @price_list = PriceList.find(params[:price_list_id])
    @price_list_line = PriceListLine.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @price_list_line }
    end
  end

  # GET /price_list_lines/new
  # GET /price_list_lines/new.json
  def new
    @products = Product.all
    @price_list = PriceList.find(params[:price_list_id])
    @price_list_line = PriceListLine.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @price_list_line }
    end
  end

  # GET /price_list_lines/1/edit
  def edit
    @products = Product.all
    @price_list = PriceList.find(params[:price_list_id])
    @price_list_line = PriceListLine.find(params[:id])
  end

  # POST /price_list_lines
  # POST /price_list_lines.json
  def create
    @products = Product.all
    @price_list = PriceList.find(params[:price_list_id])
    @price_list_line = PriceListLine.new(params[:price_list_line])
    @price_list.price_list_lines << @price_list_line
    @price_list.save
    
    respond_to do |format|
      if @price_list_line.save
        format.html { redirect_to price_list_price_list_line_path(@price_list, @price_list_line), notice: 'Price list line was successfully created.' }
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
    
    @price_list = PriceList.find(params[:price_list_id])
    @price_list_line = PriceListLine.find(params[:id])

    respond_to do |format|
      if @price_list_line.update_attributes(params[:price_list_line])
        format.html { redirect_to price_list_price_list_line_path(@price_list, @price_list_line), notice: 'Price list line was successfully updated.' }
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
    @price_list_line = PriceListLine.find(params[:id])
    @price_list_line.destroy

    respond_to do |format|
      format.html { redirect_to price_list_price_list_lines_path(@price_list), notice: 'Price list line was successfully destroyed.' }
      format.json { head :no_content }
    end
  end
end
