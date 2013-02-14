class RoutesController < ApplicationController
  load_and_authorize_resource
  
  def create_use_template
    authorize! :route , :create_use_template
    @user = current_user
    @manager = Manager.find(@user.manager_id)    
    @day_of_week = Date.today.wday
    @today = Date.today
    @status = Status.find_by_name('not visited')
    if @manager
      @template_route = TemplateRoute.find_by_manager_id_and_day_of_week(@manager.id, @day_of_week)
      if !@template_route
        redirect_to routes_path, notice: 'Tied to the current user manager is not created the route pattern for the current day of the week.'
        return
      end   
    else
      redirect_to @route, notice: 'Current user not tied to the manager.'
      return
    end
    @route = Route.find_by_manager_id_and_date(@manager.id,@today)
    if !@route
      @route = Route.create(manager_id: @manager.id, date: @today)
      @template_route.template_route_points.each do |template_route_point|
        @route_point = RoutePoint.create(route_id: @route.id, shipping_address_id: template_route_point.shipping_address.id, status_id: @status.id) 
      end
    else
      redirect_to @route, notice: 'Manager tied to the current user has already created a route for the current day of the week.'
      return        
    end   
    
    respond_to do |format|      
        format.html { redirect_to @route, notice: 'Route was successfully created.' }
        format.json { render json: @route, status: :created, location: @route }      
    end
  end
  # GET /routes
  # GET /routes.json
  def index
    @search = Route.search(params[:q])
    @routes = @search.result.page(params[:page])

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
    @route_points = @search.result.page(params[:page])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @route }
    end
  end

  # GET /routes/new
  # GET /routes/new.json
  def new
    @route = Route.new
    @managers=Manager.all
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @route }
    end
  end

  # GET /routes/1/edit
  def edit
    @route = Route.find(params[:id])
    @managers=Manager.all
  end

  # POST /routes
  # POST /routes.json
  def create
    @route = Route.new(params[:route])

    respond_to do |format|
      if @route.save
        format.html { redirect_to @route, notice: 'Route was successfully created.' }
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

    respond_to do |format|
      if @route.update_attributes(params[:route])
        format.html { redirect_to @route, notice: 'Route was successfully updated.' }
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
      format.html { redirect_to routes_url }
      format.json { head :no_content }
    end
  end
end
