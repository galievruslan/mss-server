class PriceListsController < ApplicationController
  load_and_authorize_resource :except => :show_products
  # GET /price_lists
  # GET /price_lists.json
  def index
    if params[:q]    
      @search = PriceList.search(params[:q])
      @price_lists = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = PriceList.search(params[:q])    
      @price_lists = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end
    @price_list_lines_count = ProductPrice.where(validity: true).count(:group=>:price_list_id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @price_lists }
    end
  end

  # GET /price_lists/1
  # GET /price_lists/1.json
  def show
    @price_list = PriceList.find(params[:id])
    
    if params[:q]
      @search = @price_list.product_prices.search(params[:q])
      @product_prices = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = @price_list.product_prices.search(params[:q])
      @product_prices = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end
    

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @price_list }
    end
  end

  # GET /price_lists/new
  # GET /price_lists/new.json
  def new
    @price_list = PriceList.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @price_list }
    end
  end

  # GET /price_lists/1/edit
  def edit
    @price_list = PriceList.find(params[:id])
  end

  # POST /price_lists
  # POST /price_lists.json
  def create
    @price_list = PriceList.new(params[:price_list])

    respond_to do |format|
      if @price_list.save
        format.html { redirect_to @price_list, notice: t(:price_list_created) }
        format.json { render json: @price_list, status: :created, location: @price_list }
      else
        format.html { render action: "new" }
        format.json { render json: @price_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /price_lists/1
  # PUT /price_lists/1.json
  def update
    @price_list = PriceList.find(params[:id])

    respond_to do |format|
      if @price_list.update_attributes(params[:price_list])
        format.html { redirect_to @price_list, notice: t(:price_list_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @price_list.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /price_lists/1
  # DELETE /price_lists/1.json
  def destroy
    @price_list = PriceList.find(params[:id])
    if @price_list.validity
      @price_list.update_attributes(validity: false)
    else
      @price_list.update_attributes(validity: true)
    end

    respond_to do |format|
      format.html { redirect_to price_lists_url, notice: t(:validity_changed) }
      format.json { head :no_content }
    end
  end
  
  # POST /price_lists/multiple_change
  def multiple_change
    if params[:price_list_ids]
      params[:price_list_ids].each do |price_list_id|
        @price_list = PriceList.find(price_list_id)
        if @price_list.validity
          @price_list.update_attributes(validity: false)
        else
          @price_list.update_attributes(validity: true)
        end
      end
      redirect_to price_lists_url, notice: t(:validity_changed)
    else
      redirect_to price_lists_url
    end
  end  
  
  # GET /price_lists/:id/products/:product_id
  def show_products
    @product = ProductPrice.where(price_list_id: params[:id], product_id: params[:product_id]).first

    respond_to do |format|
      format.json { render json: @product }
    end
  end
end
