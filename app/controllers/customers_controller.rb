class CustomersController < ApplicationController
  load_and_authorize_resource
  # GET /customers
  # GET /customers.json
  def index
    if params[:q]
      @search = Customer.search(params[:q])
      @customers = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = Customer.search(params[:q])    
      @customers = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end    
    
    if params[:page_size]
      page_size = params[:page_size]
    else
      page_size = 100
    end
    
    if params[:updated_at]
      @customers_json = Customer.where("updated_at >= #{params[:updated_at]}").page(params[:page]).per(page_size).includes(:shipping_addresses)
    else
      @customers_json = Customer.page(params[:page]).per(page_size).includes(:shipping_addresses)
    end    
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @customers_json.to_json(:include => [:shipping_addresses]) }
    end
  end

  # GET /customers/1
  # GET /customers/1.json
  def show
    @customer = Customer.find(params[:id])
    
    if params[:q] 
      @search = @customer.shipping_addresses.search(params[:q])
      @shipping_addresses = @search.result.page(params[:page]).per(current_user.list_page_size)
    else       
      @search = @customer.shipping_addresses.search(params[:q])
      @shipping_addresses = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @customer }
    end
  end

  # GET /customers/new
  # GET /customers/new.json
  def new
    @customer = Customer.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @customer }
    end
  end

  # GET /customers/1/edit
  def edit
    @customer = Customer.find(params[:id])
  end

  # POST /customers
  # POST /customers.json
  def create
    @customer = Customer.new(params[:customer])

    respond_to do |format|
      if @customer.save
        format.html { redirect_to @customer, notice: t(:customer_created) }
        format.json { render json: @customer, status: :created, location: @customer }
      else
        format.html { render action: "new" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /customers/1
  # PUT /customers/1.json
  def update
    @customer = Customer.find(params[:id])

    respond_to do |format|
      if @customer.update_attributes(params[:customer])
        format.html { redirect_to @customer, notice: t(:customer_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @customer.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /customers/1
  # DELETE /customers/1.json
  def destroy
    @customer = Customer.find(params[:id])
    if @customer.validity 
      @customer.update_attributes(validity: false)
    else
      @customer.update_attributes(validity: true)
    end

    respond_to do |format|
      format.html { redirect_to customers_url, notice: t(:validity_changed) }
      format.json { head :no_content }
    end
  end
  
  # POST /customers/multiple_change_validity
  def multiple_change_validity
    params[:customer_ids].each do |customer_id|
      @customer = Customer.find(customer_id)
      if @customer.validity
        @customer.update_attributes(validity: false)
      else
        @customer.update_attributes(validity: true)
      end
    end
    respond_to do |format|
      format.html { redirect_to customers_url, notice: t(:validity_changed) }
      format.json { head :no_content }
    end
  end
end
