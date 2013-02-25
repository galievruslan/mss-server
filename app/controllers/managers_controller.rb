class ManagersController < ApplicationController
  load_and_authorize_resource
  # GET /managers
  # GET /managers.json
  def index
    @search = Manager.search(params[:q])
    @managers = @search.result.page(params[:page]).per(current_user.list_page_size)
    
    if params[:page_size]
      page_size = params[:page_size]
    else
      page_size = 100
    end
    
    if params[:updated_at]
      @managers_json = Manager.where("updated_at >= #{params[:updated_at]}").page(params[:page]).per(page_size)
    else
      @managers_json = Manager.page(params[:page]).per(page_size)
    end 
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @managers_json }
    end
  end

  # GET /managers/1
  # GET /managers/1.json
  def show
    @manager = Manager.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manager }
    end
  end

  # GET /managers/new
  # GET /managers/new.json
  def new
    @manager = Manager.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manager }
    end
  end

  # GET /managers/1/edit
  def edit
    @manager = Manager.find(params[:id])
  end

  # POST /managers
  # POST /managers.json
  def create
    @manager = Manager.new(params[:manager])
    if @manager.name == 'Bali'
      redirect_to bali_path, notice: 'Bali best place in the World.'
      return
    end
    respond_to do |format|
      if @manager.save
        format.html { redirect_to @manager, notice: 'Manager was successfully created.' }
        format.json { render json: @manager, status: :created, location: @manager }
      else
        format.html { render action: "new" }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /managers/1
  # PUT /managers/1.json
  def update
    @manager = Manager.find(params[:id])

    respond_to do |format|
      if @manager.update_attributes(params[:manager])
        format.html { redirect_to @manager, notice: 'Manager was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /managers/1
  # DELETE /managers/1.json
  def destroy
    @manager = Manager.find(params[:id])
    if @manager.validity 
      @manager.update_attributes(validity: false)
    else
      @manager.update_attributes(validity: true)
    end  

    respond_to do |format|
      format.html { redirect_to managers_url }
      format.json { head :no_content }
    end
  end
end
