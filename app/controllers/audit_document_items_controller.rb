class AuditDocumentItemsController < ApplicationController
  # GET /audit_document_items
  # GET /audit_document_items.json
  def index
    @audit_document = AuditDocument.find(params[:audit_document_id])
    @search = @audit_document.audit_document_items.search(params[:q])
    @audit_document_items = @search.result.page(params[:page]).per(current_user.list_page_size)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @audit_document_items }
    end
  end

  # GET /audit_document_items/1
  # GET /audit_document_items/1.json
  def show
    @audit_document = AuditDocument.find(params[:audit_document_id])
    @audit_document_item = AuditDocumentItem.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @audit_document_item }
    end
  end

  # GET /audit_document_items/new
  # GET /audit_document_items/new.json
  def new
    @audit_document = AuditDocument.find(params[:audit_document_id])
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to audit_document_audit_document_items_path(@audit_document), notice: t(:manager_not_valid)
      return     
    end
    @audit_document_item = AuditDocumentItem.new
    @products = Product.where(validity: true)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @audit_document_item }
    end
  end

  # GET /audit_document_items/1/edit
  def edit
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to audit_document_audit_document_items_path(@audit_document), notice: t(:manager_not_valid)
      return     
    end
    @audit_document = AuditDocument.find(params[:audit_document_id])
    @audit_document_item = AuditDocumentItem.find(params[:id])
    @products = Product.where(validity: true)
  end

  # POST /audit_document_items
  # POST /audit_document_items.json
  def create
    @audit_document = AuditDocument.find(params[:audit_document_id])
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to audit_document_audit_document_items_path(@audit_document), notice: t(:manager_not_valid)
      return     
    end    
    @audit_document_item = AuditDocumentItem.new(params[:audit_document_item])
    @audit_document_item.audit_document_id = @audit_document.id
    @products = Product.where(validity: true)
    respond_to do |format|
      if @audit_document_item.save
        format.html { redirect_to audit_document_audit_document_item_path(@audit_document, @audit_document_item), notice: t(:audit_document_item_created) }
        format.json { render json: @audit_document_item, status: :created, location: @audit_document_item }
      else
        format.html { render action: "new" }
        format.json { render json: @audit_document_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /audit_document_items/1
  # PUT /audit_document_items/1.json
  def update
    @audit_document = AuditDocument.find(params[:audit_document_id])
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to audit_document_audit_document_items_path(@audit_document), notice: t(:manager_not_valid)
      return     
    end    
    @audit_document_item = AuditDocumentItem.find(params[:id])
    @products = Product.where(validity: true)
    respond_to do |format|
      if @audit_document_item.update_attributes(params[:audit_document_item])
        format.html { redirect_to audit_document_audit_document_item_path(@audit_document, @audit_document_item), notice: t(:audit_document_item_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @audit_document_item.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /audit_document_items/1
  # DELETE /audit_document_items/1.json
  def destroy
    @audit_document = AuditDocument.find(params[:audit_document_id])
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to audit_document_audit_document_items_path(@audit_document), notice: t(:manager_not_valid)
      return     
    end    
    @audit_document_item = AuditDocumentItem.find(params[:id])
    @audit_document_item.destroy

    respond_to do |format|
      format.html { redirect_to audit_document_audit_document_items_url(@audit_document), notice: t(:audit_document_item_destroyed) }
      format.json { head :no_content }
    end
  end
  
  # POST /audit_documentы/1/audit_document_items/multiple_change
  def multiple_change
    @audit_document = AuditDocument.find(params[:audit_document_id])
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to audit_document_audit_document_items_path(@audit_document), notice: t(:manager_not_valid)
      return     
    end
    if params[:audit_document_item_ids]
      params[:audit_document_item_ids].each do |audit_document_item_id|
        @audit_document_item = AuditDocumentItem.find(audit_document_item_id)
        @audit_document_item.destroy          
      end
      redirect_to audit_document_audit_document_items_url(@audit_document), notice: t(:audit_document_items_destroyed)
    else
      redirect_to audit_document_audit_document_items_url(@audit_document)
    end
  end
end
