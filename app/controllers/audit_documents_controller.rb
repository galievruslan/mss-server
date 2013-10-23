class AuditDocumentsController < ApplicationController
  load_and_authorize_resource
  # GET /audit_documents
  # GET /audit_documents.json
  def index
    @managers = Manager.all
    @shipping_addresses = ShippingAddress.all
    @search = AuditDocument.available_for_user(current_user).search(params[:q])
    @audit_documents = @search.result.page(params[:page]).per(current_user.list_page_size)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @audit_documents }
    end
  end

  # GET /audit_documents/1
  # GET /audit_documents/1.json
  def show
    @audit_document = AuditDocument.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @audit_document }
    end
  end

  # GET /audit_documents/new
  # GET /audit_documents/new.json
  def new
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to audit_documents_path, notice: t(:manager_not_valid)
      return
    end
    if current_user.manager_id
      @shipping_address_ids = ManagerShippingAddress.where(manager_id: current_user.manager_id).collect(&:shipping_address_id)
      @customer_ids= ShippingAddress.where(id: @shipping_address_ids).collect(&:customer_id)
      @customers = Customer.where(validity: true, id: @customer_ids)
      @managers = Manager.where(id: current_user.manager_id)
      @select_manager_id = Manager.find(current_user.manager_id).id
    else
      @customers = Customer.where(validity: true)
      @managers = Manager.where(validity: true)
    end
    
    @audit_document = AuditDocument.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @audit_document }
    end
  end

  # GET /audit_documents/1/edit
  def edit
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to audit_documents_path, notice: t(:manager_not_valid)
      return
    end
    @audit_document = AuditDocument.find(params[:id])
    @select_customer = @audit_document.shipping_address.customer
    @select_customer_id = @select_customer.id
    @select_manager_id = @audit_document.manager_id
    @select_shipping_address_id = @audit_document.shipping_address.id
    if current_user.manager_id
      @shipping_address_ids = ManagerShippingAddress.where(manager_id: current_user.manager_id).collect(&:shipping_address_id)
      @customer_ids= ShippingAddress.where(id: @shipping_address_ids).collect(&:customer_id)
      @customers = Customer.where(validity: true, id: @customer_ids)
      @managers = Manager.where(id: current_user.manager_id)
      @shipping_addresses = ShippingAddress.where(id: @shipping_address_ids, customer_id: @select_customer_id)
    else
      @customers = Customer.where(validity: true)
      @managers = Manager.where(validity: true)
      @shipping_addresses = @select_customer.shipping_addresses
    end  
  end

  # POST /audit_documents
  # POST /audit_documents.json
  def create
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to audit_documents_path, notice: t(:manager_not_valid)
      return      
    end
    unless params[:audit_document][:shipping_address_id] == ''
      @select_shipping_address_id = params[:audit_document][:shipping_address_id]
    end
    unless params[:audit_document][:manager_id] == ''
      @select_manager_id = params[:audit_document][:manager_id]
    end
    if current_user.manager_id
      @shipping_address_ids = ManagerShippingAddress.where(manager_id: current_user.manager_id).collect(&:shipping_address_id)
      @customer_ids = ShippingAddress.where(id: @shipping_address_ids).collect(&:customer_id)
      @customers = Customer.where(validity: true, id: @customer_ids)
      @managers = Manager.where(id: current_user.manager_id)
      unless params[:customer_id] == ''
        @select_customer_id = params[:customer_id]
        @shipping_addresses = Customer.find(params[:customer_id]).shipping_addresses.where(id: @shipping_address_ids)
      else
        params[:audit_document][:shipping_address_id] = ''
      end
    else
      @customers = Customer.where(validity: true)
      @managers = Manager.where(validity: true)
      unless params[:customer_id] == ''
        @select_customer_id = params[:customer_id]
        @shipping_addresses = Customer.find(params[:customer_id]).shipping_addresses
      else
        params[:audit_document][:shipping_address_id] = ''
      end
    end
    @audit_document = AuditDocument.new(params[:audit_document])

    respond_to do |format|
      if @audit_document.save
        format.html { redirect_to @audit_document, notice: t(:audit_document_created) }
        format.json { render json: @audit_document, status: :created, location: @audit_document }
      else
        format.html { render action: "new" }
        format.json { render json: @audit_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /audit_documents/1
  # PUT /audit_documents/1.json
  def update
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to audit_documents_path, notice: t(:manager_not_valid)
      return
    end
    
    unless params[:audit_document][:shipping_address_id] == ''
      @select_shipping_address_id = params[:audit_document][:shipping_address_id]
    end
    unless params[:audit_document][:manager_id] == ''
      @select_manager_id = params[:audit_document][:manager_id]
    end
    @audit_document = AuditDocument.find(params[:id])
    
    if current_user.manager_id
      @shipping_address_ids = ManagerShippingAddress.where(manager_id: current_user.manager_id).collect(&:shipping_address_id)
      @customer_ids = ShippingAddress.where(id: @shipping_address_ids).collect(&:customer_id)
      @customers = Customer.where(validity: true, id: @customer_ids)
      @managers = Manager.where(id: current_user.manager_id)
      unless params[:customer_id] == ''
        @select_customer_id = params[:customer_id]
        @shipping_addresses = ShippingAddress.where(id: @shipping_address_ids, customer_id: @select_customer_id)
      else
        @select_customer = @audit_document.shipping_address.customer
        @select_customer_id = @select_customer.id
        @shipping_addresses = @select_customer.shipping_addresses.where(id: @shipping_address_ids)
      end
    else
      unless params[:customer_id] == ''
        @select_customer_id = params[:customer_id]
        @shipping_addresses = Customer.find(params[:customer_id]).shipping_addresses
      else
        @select_customer = @audit_document.shipping_address.customer
        @select_customer_id = @select_customer.id
        @shipping_addresses = @select_customer.shipping_addresses
      end
      @customers = Customer.where(validity: true)
      @managers = Manager.where(validity: true)
    end

    respond_to do |format|
      if @audit_document.update_attributes(params[:audit_document])
        format.html { redirect_to @audit_document, notice: t(:audit_document_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @audit_document.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audit_documents/1
  # DELETE /audit_documents/1.json
  def destroy
    @audit_document = AuditDocument.find(params[:id])
    @audit_document.destroy

    respond_to do |format|
      format.html { redirect_to audit_documents_url, notice: t(:audit_document_destroyed) }
      format.json { head :no_content }
    end
  end
  
  # GET /audit_documents/update_shipping_addresses
  def update_shipping_addresses
    if current_user.manager_id
      @shipping_address_ids = ManagerShippingAddress.where(manager_id: current_user.manager_id).collect(&:shipping_address_id)
      @shipping_addresses = ShippingAddress.where(id: @shipping_address_ids, customer_id: params[:customer_id])
    else
      @shipping_addresses = Customer.find(params[:customer_id]).shipping_addresses
    end
    render :partial => "shipping_addresses", :object => @shipping_addresses  
  end
  
  # POST /audit_documents/multiple_change
  def multiple_change
    if params[:audit_document_ids]
      params[:audit_document_ids].each do |audit_document_id|
        @audit_document = AuditDocument.find(audit_document_id)
        @audit_document.destroy
      end
      redirect_to audit_documents_url, notice: t(:audit_documents_destroyed)          
    else
      redirect_to audit_documents_url
    end
  end
end
