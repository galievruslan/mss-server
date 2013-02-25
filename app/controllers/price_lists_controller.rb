class PriceListsController < ApplicationController
  load_and_authorize_resource
  # GET /price_lists
  # GET /price_lists.json
  def index
    @search = PriceList.search(params[:q])
    @price_lists = @search.result.page(params[:page]).per(current_user.list_page_size)
    
    if params[:page_size]
      page_size = params[:page_size]
    else
      page_size = 100
    end
    
    if params[:updated_at]
      @price_lists_json = PriceList.where("updated_at >= #{params[:updated_at]}").page(params[:page]).per(page_size).includes(:price_list_lines)
    else
      @price_lists_json = PriceList.page(params[:page]).per(page_size).includes(:price_list_lines)
    end 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @price_lists_json.to_json(:include => [:price_list_lines]) }
    end
  end

  # GET /price_lists/1
  # GET /price_lists/1.json
  def show
    @price_list = PriceList.find(params[:id])
    @search = @price_list.price_list_lines.search(params[:q])
    @price_list_lines = @search.result.page(params[:page]).per(current_user.list_page_size)

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
        format.html { redirect_to @price_list, notice: 'Price list was successfully created.' }
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
        format.html { redirect_to @price_list, notice: 'Price list was successfully updated.' }
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
      format.html { redirect_to price_lists_url }
      format.json { head :no_content }
    end
  end
end
