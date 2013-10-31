class ManagersController < ValidableModelController
  load_and_authorize_resource
  # GET /managers
  # GET /managers.json
  def index
    if params[:q]
      @search = Manager.search(params[:q])
      @managers = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = Manager.search(params[:q])    
      @managers = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end   
    
    @warehouses = Warehouse.all
    @manager_shipping_addresses_count = ManagerShippingAddress.where(validity: true).count(:group=>:manager_id)
    @manager_warehouses_count = ManagerWarehouse.where(validity: true).count(:group=>:manager_id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @managers }
    end
  end

  # GET /managers/1
  # GET /managers/1.json
  def show
    @manager = Manager.find(params[:id])
    if User.find_by_manager_id(@manager.id)
      if User.find_by_manager_id(@manager.id).locations.present?
        @location = User.find_by_manager_id(@manager.id).locations.last.to_gmaps4rails
      end
    end
    if params[:q]
      @search = @manager.manager_shipping_addresses.search(params[:q])
      @manager_shipping_addresses = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = @manager.manager_shipping_addresses.search(params[:q])
      @manager_shipping_addresses = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manager }
    end
  end

  # GET /managers/new
  # GET /managers/new.json
  def new
    @manager = Manager.new
    @warehouses = Warehouse.where(validity: true)
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manager }
    end
  end

  # GET /managers/1/edit
  def edit
    @manager = Manager.find(params[:id])
    @warehouses = Warehouse.where(validity: true)
  end

  # POST /managers
  # POST /managers.json
  def create
    @warehouses = Warehouse.where(validity: true)
    @manager = Manager.new(params[:manager])
    if @manager.name == 'Bali'
      redirect_to bali_path, notice: 'Bali best place in the World.'
      return
    end
    respond_to do |format|
      if @manager.save
        format.html { redirect_to @manager, notice: t(:manager_created) }
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
    @warehouses = Warehouse.where(validity: true)

    respond_to do |format|
      if @manager.update_attributes(params[:manager])
        format.html { redirect_to @manager, notice: t(:manager_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manager.errors, status: :unprocessable_entity }
      end
    end
  end
end
