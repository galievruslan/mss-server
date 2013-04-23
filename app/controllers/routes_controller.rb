class RoutesController < ApplicationController
  load_and_authorize_resource
  
  # GET /routes/current
  # GET /routes/current.json
  def current
    authorize! :route , :current
    @user = current_user
    if @user.manager_id
      @manager = Manager.find(@user.manager_id)    
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
    @search = Route.search(params[:q])
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
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @route }
    end
  end

  # GET /routes/new
  # GET /routes/new.json
  def new
    @route = Route.new
    if current_user.manager_id
      @managers = Manager.where(id: current_user.manager_id)
    else
      @managers = Manager.where(validity: true)
    end
    
    @shipping_addresses = ShippingAddress.where(validity: true)
    @statuses = Status.where(validity: true)    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @route }
    end
  end

  # GET /routes/1/edit
  def edit
    @route = Route.find(params[:id])
    if current_user.manager_id
      @managers = Manager.where(id: current_user.manager_id)
    else
      @managers = Manager.where(validity: true)
    end
    @shipping_addresses = ShippingAddress.where(validity: true)
    @statuses = Status.where(validity: true)
  end

  # POST /routes
  # POST /routes.json
  def create
    @route = Route.new(params[:route])
    if current_user.manager_id
      @managers = Manager.where(id: current_user.manager_id)
    else
      @managers = Manager.where(validity: true)
    end
    @shipping_addresses = ShippingAddress.where(validity: true)
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
    @route = Route.find(params[:id])   
    if current_user.manager_id
      @managers = Manager.where(id: current_user.manager_id)
    else
      @managers = Manager.where(validity: true)
    end
    @shipping_addresses = ShippingAddress.where(validity: true)
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
    @route = Route.find(params[:id])
    @route.destroy

    respond_to do |format|
      format.html { redirect_to routes_url, notice: t(:route_destroyed) }
      format.json { head :no_content }
    end
  end
  
  # POST /routes/multiple_change
  def multiple_change
    if params[:route_ids]
      params[:route_ids].each do |route_id|
        @route = Route.find(route_id)
        if @route.validity
          @route.update_attributes(validity: false)
        else
          @route.update_attributes(validity: true)
        end
      end
      redirect_to routes_url, notice: t(:validity_changed)
    else
      redirect_to routes_url
    end
  end
end
