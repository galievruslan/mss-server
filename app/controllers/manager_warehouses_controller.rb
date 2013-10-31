class ManagerWarehousesController < ValidableModelController
  # GET /manager/1/manager_warehouses
  # GET /manager/1/manager_warehouses.json
  def index
    @manager = Manager.find(params[:manager_id])
    
    if params[:q]
      @search = @manager.manager_warehouses.search(params[:q])
      @manager_warehouses = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = @manager.manager_warehouses.search(params[:q])
      @manager_warehouses = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @manager_warehouses }
    end
  end

  # GET /manager/1/manager_warehouses/1
  # GET /manager/1/manager_warehouses/1.json
  def show
    @manager = Manager.find(params[:manager_id])
    @manager_warehouse = ManagerWarehouse.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @manager_warehouse }
    end
  end

  # GET /manager/1/manager_warehouses/new
  # GET /manager/1/manager_warehouses/new.json
  def new
    @manager = Manager.find(params[:manager_id])
    @warehouses = Warehouse.where(validity: true)
    @manager_warehouse = ManagerWarehouse.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @manager_warehouse }
    end
  end

  # GET /manager/1/manager_warehouses/1/edit
  def edit
    @manager = Manager.find(params[:manager_id])
    @warehouses = Warehouse.where(validity: true)
    @manager_warehouse = ManagerWarehouse.find(params[:id])
  end

  # POST /manager/1/manager_warehouses
  # POST /manager/1/manager_warehouses.json
  def create
    @manager = Manager.find(params[:manager_id])
    @warehouses = Warehouse.where(validity: true)
    @manager_warehouse = ManagerWarehouse.new(params[:manager_warehouse])
    @manager.manager_warehouses << @manager_warehouse
    @manager.save

    respond_to do |format|
      if @manager_warehouse.save
        format.html { redirect_to manager_manager_warehouses_path(@manager), notice: t(:manager_warehouse_created) }
        format.json { render json: @manager_warehouse, status: :created, location: @manager_warehouse }
      else
        format.html { render action: "new" }
        format.json { render json: @manager_warehouse.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /manager/1/manager_warehouses/1
  # PUT /manager/1/manager_warehouses/1.json
  def update
    @manager = Manager.find(params[:manager_id])
    @warehouses = Warehouse.where(validity: true)
    @manager_warehouse = ManagerWarehouse.find(params[:id])

    respond_to do |format|
      if @manager_warehouse.update_attributes(params[:manager_warehouse])
        format.html { redirect_to manager_manager_warehouses_path(@manager), notice: t(:manager_warehouse_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @manager_warehouse.errors, status: :unprocessable_entity }
      end
    end
  end
end
