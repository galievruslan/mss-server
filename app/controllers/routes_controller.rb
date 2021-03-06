class RoutesController < ApplicationController
  load_and_authorize_resource
  
  # GET /routes/current
  # GET /routes/current.json
  def current
    authorize! :route , :current
    @user = current_user
    if @user.role?('manager') and @user.manager_id
      @manager = Manager.find(@user.manager_id) 
      if !@manager.validity
        redirect_to routes_path, notice: t(:manager_not_valid)
        return      
      end      
    end
    @day_of_week = Date.today.wday
    @today = Date.today
    @status = Status.find_by_name(Settings.default_route_point_status)
    if @manager
      @template_route = TemplateRoute.find_by_manager_id_and_day_of_week(@manager.id, @day_of_week)
      if !@template_route
        @route = Route.find_by_manager_id_and_date(@manager.id, @today)
        if !@route
          @route = Route.create(manager_id: @manager.id, date: @today)
          respond_to do |format|      
            format.html { redirect_to @route, notice: t(:create_empty_route) }
            format.json { render json: @route, status: :created, location: @route }      
          end
          return
        else
          respond_to do |format|      
            format.html { redirect_to @route }
            format.json { render json: @route, status: :created, location: @route }      
          end          
        end
      else
        @route = Route.find_by_manager_id_and_date(@manager.id, @today)        
        if !@route
          @route = Route.new(manager_id: @manager.id, date: @today)
          @template_route.template_route_points.each do |template_route_point|
            @route_point = RoutePoint.new(shipping_address_id: template_route_point.shipping_address.id, status_id: @status.id)
            @route.route_points << @route_point
          end
          @route.save
          respond_to do |format|      
            format.html { redirect_to @route, notice: t(:route_created) }
            format.json { render json: @route.to_json(:include => [:route_points]), status: :created, location: @route }      
          end
          return
        else
          respond_to do |format|      
            format.html { redirect_to @route }
            format.json { render json: @route.to_json(:include => [:route_points]), status: :created, location: @route }      
          end    
          return  
        end        
      end   
    else
      redirect_to routes_path, notice: t(:current_user_no_manager)
      return
    end
  end
  
  # GET /routes
  # GET /routes.json
  def index
    if current_user.role? :manager and current_user.manager_id
      @search = Route.where(manager_id: current_user.manager_id).search(params[:q])
    else
      @search = Route.search(params[:q])
    end    
    @routes = @search.result.page(params[:page]).per(current_user.list_page_size)
    @managers = Manager.all
    @route_points_count = RoutePoint.count(:group=>:route_id)
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @routes }
    end
  end

  # GET /routes/1
  # GET /routes/1.json
  def show
    @route = Route.find(params[:id])
    @search = @route.route_points.search(params[:q])
    @route_points = @search.result.page(params[:page]).per(current_user.list_page_size)
    @statuses = Status.where(validity: true)
    @orders_count = Order.count(:group=>:route_point_id)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @route }
    end
  end

  # GET /routes/new
  # GET /routes/new.json
  def new
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to routes_path, notice: t(:manager_not_valid)
      return
    end
    @route = Route.new    
    if current_user.manager_id
      @route.manager_id = current_user.manager_id
      @managers = Manager.where(id: current_user.manager_id)
      @shipping_address_ids = ManagerShippingAddress.where(validity: true, manager_id: current_user.manager_id).select('shipping_address_id').map {|x| x.shipping_address_id}
      @shipping_addresses = ShippingAddress.where(validity: true, id: @shipping_address_ids)
    else
      @managers = Manager.where(validity: true)
      @shipping_addresses = []
    end    
    @statuses = Status.where(validity: true)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @route }
    end
  end

  # GET /routes/1/edit
  def edit
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to routes_path, notice: t(:manager_not_valid)      
    end
    @route = Route.find(params[:id])
    if current_user.manager_id
      @managers = Manager.where(id: current_user.manager_id)
      @shipping_address_ids = ManagerShippingAddress.where(validity: true, manager_id: current_user.manager_id).select('shipping_address_id').map {|x| x.shipping_address_id}
      @shipping_addresses = ShippingAddress.where(validity: true, id: @shipping_address_ids)
    else
      @managers = Manager.where(validity: true)
      @shipping_addresses = Manager.find(@route.manager_id).shipping_addresses.where(validity: true)
    end    
    @statuses = Status.where(validity: true)
  end

  # POST /routes
  # POST /routes.json
  def create
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to routes_path, notice: t(:manager_not_valid)
      return
    end
    @route = Route.new(params[:route])
    if current_user.manager_id
      @managers = Manager.where(id: current_user.manager_id)
      @shipping_address_ids = ManagerShippingAddress.where(validity: true, manager_id: current_user.manager_id).select('shipping_address_id').map {|x| x.shipping_address_id}
      @shipping_addresses = ShippingAddress.where(validity: true, id: @shipping_address_ids)
    else
      @managers = Manager.where(validity: true)
      if params[:route][:manager_id] != ""
        @shipping_addresses = Manager.find(params[:route][:manager_id]).shipping_addresses.where(validity: true)
      end
    end    
    @statuses = Status.where(validity: true)
    
    respond_to do |format|
      if @route.save
        format.html { redirect_to @route, notice: t(:route_created) }
        format.json { render json: @route, status: :created, location: @route }
      else
        format.html { render action: "new" }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /routes/1
  # PUT /routes/1.json
  def update
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to routes_path, notice: t(:manager_not_valid)
      return
    end  
    @route = Route.find(params[:id])   
    if current_user.manager_id
      @managers = Manager.where(id: current_user.manager_id)
      @shipping_address_ids = ManagerShippingAddress.where(validity: true, manager_id: current_user.manager_id).select('shipping_address_id').map {|x| x.shipping_address_id}
      @shipping_addresses = ShippingAddress.where(validity: true, id: @shipping_address_ids)
    else
      @managers = Manager.where(validity: true)
      if params[:route][:manager_id] != ""
        @shipping_addresses = Manager.find(params[:route][:manager_id]).shipping_addresses.where(validity: true)
      end
    end    
    @statuses = Status.where(validity: true)
    
    respond_to do |format|
      if @route.update_attributes(params[:route])
        format.html { redirect_to @route, notice: t(:route_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /routes/1
  # DELETE /routes/1.json
  def destroy
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to routes_path, notice: t(:manager_not_valid)
      return
    end
    @route = Route.find(params[:id])
    @route.destroy

    respond_to do |format|
      format.html { redirect_to routes_url, notice: t(:route_destroyed) }
      format.json { head :no_content }
    end
  end
  
  # POST /routes/multiple_change
  def multiple_change
    if current_user.role?('manager') and !Manager.find(current_user.manager_id).validity
      redirect_to routes_path, notice: t(:manager_not_valid)
      return
    end
    if params[:route_ids]
      params[:route_ids].each do |route_id|
        @route = Route.find(route_id)
        @route.destroy         
      end
      redirect_to routes_url, notice: t(:routes_destroyed)
    else
      redirect_to routes_url
    end
  end
  
  def get_shipping_address_list
    @shipping_address_ids = ManagerShippingAddress.where(validity: true, manager_id: params[:manager_id]).select('shipping_address_id').map {|x| x.shipping_address_id}
    @shipping_addresses = ShippingAddress.where(validity: true, id: @shipping_address_ids)
    @statuses = Status.where(validity: true)
    render :partial => "route_point_fields_new"  
  end
end
