class RoutePointPhotosController < ApplicationController
  load_and_authorize_resource
  # GET /route_point_photos
  # GET /route_point_photos.json
  def index
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.find(params[:route_point_id])
    @route_point_photos = @route_point.route_point_photos.page(params[:page]).per(current_user.list_page_size)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @route_point_photos }
    end
  end
  
  # GET /route_point_photos
  # GET /route_point_photos.json
  def list
    @search = RoutePointPhoto.search(params[:q])
    @route_point_photos = @search.result.page(params[:page]).per(12)
    @managers = Manager.all
    respond_to do |format|
      format.html #list.html.erb
      format.json { render json: @route_point_photos }
    end
  end
  
  # GET /route_point_photos/download
  def download
    @route_point_photo = RoutePointPhoto.find(params[:id])
    send_file @route_point_photo.photo.large.path, :filename => "photo.jpg", :type => "jmage/jpeg"
  end

  # GET /route_point_photos/1
  # GET /route_point_photos/1.json
  def show
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.find(params[:route_point_id])
    @route_point_photo = RoutePointPhoto.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @route_point_photo }
    end
  end

  # GET /route_point_photos/new
  # GET /route_point_photos/new.json
  def new
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.find(params[:route_point_id])
    @route_point_photo = RoutePointPhoto.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @route_point_photo }
    end
  end

  # GET /route_point_photos/1/edit
  def edit
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.find(params[:route_point_id])
    @route_point_photo = RoutePointPhoto.find(params[:id])
  end

  # POST /route_point_photos
  # POST /route_point_photos.json
  def create
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.find(params[:route_point_id])
    params[:route_point_photo][:route_point_id] = params[:route_point_id]
    @route_point_photo = RoutePointPhoto.new(params[:route_point_photo])
    
    respond_to do |format|
      if @route_point_photo.save
        format.html { redirect_to route_route_point_photo_path(@route, @route_point, @route_point_photo), notice: t(:route_point_photo_created) }
        format.json { render json: @route_point_photo, status: :created, location: @route_point_photo }
      else
        format.html { render action: "new" }
        format.json { render json: @route_point_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /route_point_photos/1
  # PUT /route_point_photos/1.json
  def update
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.find(params[:route_point_id])
    @route_point_photo = RoutePointPhoto.find(params[:id])

    respond_to do |format|
      if @route_point_photo.update_attributes(params[:route_point_photo])
        format.html { redirect_to route_route_point_photo_path(@route, @route_point, @route_point_photo), notice: t(:route_point_photo_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @route_point_photo.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /route_point_photos/1
  # DELETE /route_point_photos/1.json
  def destroy
    @route = Route.find(params[:route_id])
    @route_point = RoutePoint.find(params[:route_point_id])
    @route_point_photo = RoutePointPhoto.find(params[:id])
    @route_point_photo.destroy

    respond_to do |format|
      format.html { redirect_to route_route_point_photos_url(@route,@route_point), notice: t(:route_point_photo_destroyed) }
      format.json { head :no_content }
    end
  end
end
