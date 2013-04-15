class TemplateRoutesController < ApplicationController
  # GET /template_routes
  # GET /template_routes.json
  def index
    @days_of_week = [0,1,2,3,4,5,6]
    @search = TemplateRoute.search(params[:q])
    @template_routes = @search.result.page(params[:page]).per(current_user.list_page_size)
    @managers = Manager.where(validity: true)
    if params[:updated_at]
      if params[:manager_id]
        @template_routes_json = TemplateRoute.where("updated_at >= #{params[:updated_at]} and manager_id = #{params[:manager_id]}").includes(:template_route_points)
      else
        @template_routes_json = TemplateRoute.where("updated_at >= #{params[:updated_at]}").includes(:template_route_points)
      end      
    else
      if params[:manager_id]
        @template_routes_json = TemplateRoute.where("manager_id = #{params[:manager_id]}").includes(:template_route_points)
      else
        @template_routes_json = TemplateRoute.includes(:template_route_points)
      end      
    end 
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @template_routes_json.to_json(:include => [:template_route_points]) }
    end
  end

  # GET /template_routes/1
  # GET /template_routes/1.json
  def show
    @template_route = TemplateRoute.find(params[:id])
    @search = @template_route.template_route_points.search(params[:q])
    @template_route_points = @search.result.page(params[:page]).per(current_user.list_page_size)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @template_route }
    end
  end

  # GET /template_routes/new
  # GET /template_routes/new.json
  def new
    @days_of_week = [0,1,2,3,4,5,6]
    @managers = Manager.where(validity: true)
    @template_route = TemplateRoute.new
    @shipping_addresses = ShippingAddress.where(validity: true)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @template_route }
    end
  end

  # GET /template_routes/1/edit
  def edit
    @days_of_week = [0,1,2,3,4,5,6]
    @managers = Manager.where(validity: true)
    @template_route = TemplateRoute.find(params[:id])
    @shipping_addresses = ShippingAddress.where(validity: true)
  end

  # POST /template_routes
  # POST /template_routes.json
  def create
    @days_of_week = [0,1,2,3,4,5,6]
    @managers = Manager.where(validity: true)
    @template_route = TemplateRoute.new(params[:template_route])
    @shipping_addresses = ShippingAddress.where(validity: true)

    respond_to do |format|
      if @template_route.save
        format.html { redirect_to @template_route, notice: t(:template_route_created) }
        format.json { render json: @template_route, status: :created, location: @template_route }
      else
        format.html { render action: "new" }
        format.json { render json: @template_route.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /template_routes/1
  # PUT /template_routes/1.json
  def update
    @days_of_week = [0,1,2,3,4,5,6]
    @managers = Manager.where(validity: true)
    @template_route = TemplateRoute.find(params[:id])
    @shipping_addresses = ShippingAddress.where(validity: true)

    respond_to do |format|
      if @template_route.update_attributes(params[:template_route])
        format.html { redirect_to @template_route, notice: t(:template_route_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @template_route.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /template_routes/1
  # DELETE /template_routes/1.json
  def destroy
    @template_route = TemplateRoute.find(params[:id])
    @template_route.destroy

    respond_to do |format|
      format.html { redirect_to template_routes_url, notice: t(:template_route_destroyed) }
      format.json { head :no_content }
    end
  end
end
