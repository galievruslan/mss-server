class TemplateRoutesController < ApplicationController
  # GET /template_routes
  # GET /template_routes.json
  def index
    @days_of_week = [0,1,2,3,4,5,6]
    if params[:q]
      @search = TemplateRoute.search(params[:q])
      @template_routes = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = TemplateRoute.search(params[:q])
      @template_routes = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end
    
    @managers = Manager.all
    @template_route_points_count = TemplateRoutePoint.count(:group=>:template_route_id)
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @template_routes }
    end
  end

  # GET /template_routes/1
  # GET /template_routes/1.json
  def show    
    @template_route = TemplateRoute.find(params[:id])
    if params[:q]
      @search = @template_route.template_route_points.search(params[:q])
      @template_route_points = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = @template_route.template_route_points.search(params[:q])
      @template_route_points = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end
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
    @shipping_addresses = []
    
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
    @shipping_addresses = Manager.find(@template_route.manager_id).shipping_addresses.where(validity: true)
  end

  # POST /template_routes
  # POST /template_routes.json
  def create
    @days_of_week = [0,1,2,3,4,5,6]
    @managers = Manager.where(validity: true)
    @template_route = TemplateRoute.new(params[:template_route])
    
    if params[:template_route][:manager_id] != ""
      @shipping_addresses =  Manager.find(params[:template_route][:manager_id]).shipping_addresses.where(validity: true)
    else
      @shipping_addresses = []
    end
    

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
    
    if params[:template_route][:manager_id] != ""
      @shipping_addresses =  Manager.find(params[:template_route][:manager_id]).shipping_addresses.where(validity: true)
    else
      @shipping_addresses = []
    end
    
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
    if @template_route.validity
      @template_route.update_attributes(validity: false)
    else
      @template_route.update_attributes(validity: true)
    end
    
    respond_to do |format|
      format.html { redirect_to template_routes_url, notice: t(:validity_changed) }
      format.json { head :no_content }
    end
  end
  
  # GET /template_routes/get_shipping_address_list
  def get_shipping_address_list
    @shipping_address_ids = ManagerShippingAddress.where(validity: true, manager_id: params[:manager_id]).select('shipping_address_id').map {|x| x.shipping_address_id}
    @shipping_addresses = ShippingAddress.where(validity: true, id: @shipping_address_ids) 
    render :partial => "template_route_point_fields_new", :object => @shipping_addresses  
  end
  
  # POST /template_routes/multiple_change
  def multiple_change
    if params[:template_route_ids]
      params[:template_route_ids].each do |template_route_id|
        @template_route = TemplateRoute.find(template_route_id)
        if @template_route.validity
          @template_route.update_attributes(validity: false)
        else
          @template_route.update_attributes(validity: true)
        end
      end
      redirect_to template_routes_url, notice: t(:validity_changed)
    else
      redirect_to template_routes_url
    end
  end
end
