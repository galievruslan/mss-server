class TemplateRoutesController < ApplicationController
  # GET /template_routes
  # GET /template_routes.json
  def index
    @template_routes = TemplateRoute.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @template_routes }
    end
  end

  # GET /template_routes/1
  # GET /template_routes/1.json
  def show
    @template_route = TemplateRoute.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @template_route }
    end
  end

  # GET /template_routes/new
  # GET /template_routes/new.json
  def new
    @days_of_week = [0,1,2,3,4,5,6]
    @managers = Manager.all
    @template_route = TemplateRoute.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @template_route }
    end
  end

  # GET /template_routes/1/edit
  def edit
    @days_of_week = [0,1,2,3,4,5,6]
    @managers = Manager.all
    @template_route = TemplateRoute.find(params[:id])
  end

  # POST /template_routes
  # POST /template_routes.json
  def create
    @template_route = TemplateRoute.new(params[:template_route])

    respond_to do |format|
      if @template_route.save
        format.html { redirect_to @template_route, notice: 'Template route was successfully created.' }
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
    @template_route = TemplateRoute.find(params[:id])

    respond_to do |format|
      if @template_route.update_attributes(params[:template_route])
        format.html { redirect_to @template_route, notice: 'Template route was successfully updated.' }
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
      format.html { redirect_to template_routes_url }
      format.json { head :no_content }
    end
  end
end
