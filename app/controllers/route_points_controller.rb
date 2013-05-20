class RoutePointsController < ApplicationController
  load_and_authorize_resource
  # GET /route_points
  # GET /route_points.json
  def index
    @route = Route.find(params[:route_id])
    @search = @route.route_points.search(params[:q])
    @route_points = @search.result.page(params[:page]).per(current_user.list_page_size)
    @statuses = Status.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @route_points }
    end
  end

  # GET /route_points/1
  # GET /route_points/1.json
  def show
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @route_point }
    end
  end

  # GET /route_points/new
  # GET /route_points/new.json
  def new
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.new
    @manager_shipping_address_ids = ManagerShippingAddress.where(manager_id: @route.manager_id).select('shipping_address_id').map {|x| x.shipping_address_id}
    @shipping_addresses = ShippingAddress.where(validity: true).where(id: @manager_shipping_address_ids)
    @statuses = Status.where(validity: true)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @route_point }
    end
  end

  # GET /route_points/1/edit
  def edit
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.find(params[:id])
    @manager_shipping_address_ids = ManagerShippingAddress.where(manager_id: @route.manager_id).select('shipping_address_id').map {|x| x.shipping_address_id}
    @shipping_addresses = ShippingAddress.where(validity: true).where(id: @manager_shipping_address_ids)
    @statuses = Status.where(validity: true)
  end

  # POST /route_points
  # POST /route_points.json
  def create
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.new(params[:route_point])
    @manager_shipping_address_ids = ManagerShippingAddress.where(manager_id: @route.manager_id).select('shipping_address_id').map {|x| x.shipping_address_id}
    @shipping_addresses = ShippingAddress.where(validity: true).where(id: @manager_shipping_address_ids)
    @statuses = Status.where(validity: true)
    
    @route.route_points << @route_point
    @route.save
    
    respond_to do |format|
      if @route_point.save
        format.html { redirect_to route_route_point_path(@route, @route_point), notice: t(:route_point_created) }
        format.json { render json: @route_point, status: :created, location: @route_point }
      else
        format.html { render action: "new" }
        format.json { render json: @route_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /route_points/1
  # PUT /route_points/1.json
  def update    
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.find(params[:id])
    @manager_shipping_address_ids = ManagerShippingAddress.where(manager_id: @route.manager_id).select('shipping_address_id').map {|x| x.shipping_address_id}
    @shipping_addresses = ShippingAddress.where(validity: true).where(id: @manager_shipping_address_ids)
    @statuses = Status.where(validity: true)

    respond_to do |format|
      if @route_point.update_attributes(params[:route_point])
        format.html { redirect_to route_route_point_path(@route, @route_point), notice: t(:route_point_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @route_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /route_points/1
  # DELETE /route_points/1.json
  def destroy
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.find(params[:id])
    @route_point.destroy

    respond_to do |format|
      format.html { redirect_to route_route_points_path(@route), notice: t(:route_point_destroyed) }
      format.json { head :no_content }
    end
  end
  
  # POST /routes/1/route_points/multiple_change
  def multiple_change
    @route = Route.find(params[:route_id])
    if params[:route_point_ids]
      params[:route_point_ids].each do |route_point_id|
        @route_point = RoutePoint.find(route_point_id)
        @route_point.destroy
      end
      redirect_to route_route_points_path(@route), notice: t(:route_points_destroyed)
    else
      redirect_to route_route_points_path(@route)
    end
  end
end
