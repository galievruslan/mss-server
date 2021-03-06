class TemplateRoutePointsController < ValidableModelController
  # GET /template_route_points
  # GET /template_route_points.json
  def index
    @template_route = TemplateRoute.find(params[:template_route_id])
    if params[:q]
      @search = @template_route.template_route_points.search(params[:q])
      @template_route_points = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = @template_route.template_route_points.search(params[:q])
      @template_route_points = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @template_route_points }
    end
  end

  # GET /template_route_points/1
  # GET /template_route_points/1.json
  def show
    @template_route = TemplateRoute.find(params[:template_route_id])
    @template_route_point = TemplateRoutePoint.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @template_route_point }
    end
  end

  # GET /template_route_points/new
  # GET /template_route_points/new.json
  def new    
    @template_route = TemplateRoute.find(params[:template_route_id])
    @template_route_point = TemplateRoutePoint.new
    @manager_shipping_address_ids = ManagerShippingAddress.where(manager_id: @template_route.manager_id).select('shipping_address_id').map {|x| x.shipping_address_id}
    @shipping_addresses = ShippingAddress.where(validity: true).where(id: @manager_shipping_address_ids)
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @template_route_point }
    end
  end

  # GET /template_route_points/1/edit
  def edit
    @template_route = TemplateRoute.find(params[:template_route_id])
    @template_route_point = TemplateRoutePoint.find(params[:id])
    @manager_shipping_address_ids = ManagerShippingAddress.where(manager_id: @template_route.manager_id).select('shipping_address_id').map {|x| x.shipping_address_id}
    @shipping_addresses = ShippingAddress.where(validity: true).where(id: @manager_shipping_address_ids)
  end

  # POST /template_route_points
  # POST /template_route_points.json
  def create
    @template_route = TemplateRoute.find(params[:template_route_id])
    @template_route_point = TemplateRoutePoint.new(params[:template_route_point])
    @manager_shipping_address_ids = ManagerShippingAddress.where(manager_id: @template_route.manager_id).select('shipping_address_id').map {|x| x.shipping_address_id}
    @shipping_addresses = ShippingAddress.where(validity: true).where(id: @manager_shipping_address_ids)
    @template_route.template_route_points << @template_route_point
    
    respond_to do |format|
      if @template_route_point.save
        format.html { redirect_to template_route_template_route_points_path(@template_route), notice: t(:template_route_point_created) }
        format.json { render json: @template_route_point, status: :created, location: @template_route_point }
      else
        format.html { render action: "new" }
        format.json { render json: @template_route_point.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /template_route_points/1
  # PUT /template_route_points/1.json
  def update
    @template_route = TemplateRoute.find(params[:template_route_id])
    @template_route_point = TemplateRoutePoint.find(params[:id])
    @manager_shipping_address_ids = ManagerShippingAddress.where(manager_id: @template_route.manager_id).select('shipping_address_id').map {|x| x.shipping_address_id}
    @shipping_addresses = ShippingAddress.where(validity: true).where(id: @manager_shipping_address_ids)

    respond_to do |format|
      if @template_route_point.update_attributes(params[:template_route_point])
        format.html { redirect_to template_route_template_route_points_path(@template_route), notice: t(:template_route_point_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @template_route_point.errors, status: :unprocessable_entity }
      end
    end
  end
end
