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
    @route=Route.find(params[:route_id])
    @route_point = RoutePoint.new
    @shipping_addresses = ShippingAddress.all
    @statuses = Status.all

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @route_point }
    end
  end

  # GET /route_points/1/edit
  def edit
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.find(params[:id])
    @shipping_addresses = ShippingAddress.all
    @statuses = Status.all
  end

  # POST /route_points
  # POST /route_points.json
  def create
    @route = sRoute.find(params[:route_id])
    @route_point = RoutePoint.new(params[:route_point])
    @route.route_points << @route_point
    @route.save
    
    respond_to do |format|
      if @route_point.save
        format.html { redirect_to route_route_point_path(@route, @route_point), notice: 'Route point was successfully created.' }
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

    respond_to do |format|
      if @route_point.update_attributes(params[:route_point])
        format.html { redirect_to route_route_point_path(@route, @route_point), notice: 'Route point was successfully updated.' }
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
      format.html { redirect_to route_route_points_path(@route) }
      format.json { head :no_content }
    end
  end
end
