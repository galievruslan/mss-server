class StatusesController < ApplicationController
  load_and_authorize_resource
  # GET /statuses
  # GET /statuses.json
  def index
    @search = Status.search(params[:q])
    @statuses = @search.result.page(params[:page]).per(current_user.list_page_size)
    
    if params[:page_size]
      page_size = params[:page_size]
    else
      page_size = 100
    end
    
    if params[:updated_at]
      @statuses_json = Status.where("updated_at >= #{params[:updated_at]}").page(params[:page]).per(page_size)
    else
      @statuses_json = Status.page(params[:page]).per(page_size)
    end
    
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @statuses_json }
    end
  end

  # GET /statuses/1
  # GET /statuses/1.json
  def show
    @status = Status.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/new
  # GET /statuses/new.json
  def new
    @status = Status.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @status }
    end
  end

  # GET /statuses/1/edit
  def edit
    @status = Status.find(params[:id])
  end

  # POST /statuses
  # POST /statuses.json
  def create
    @status = Status.new(params[:status])

    respond_to do |format|
      if @status.save
        format.html { redirect_to @status, notice: t(:status_created) }
        format.json { render json: @status, status: :created, location: @status }
      else
        format.html { render action: "new" }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /statuses/1
  # PUT /statuses/1.json
  def update
    @status = Status.find(params[:id])

    respond_to do |format|
      if @status.update_attributes(params[:status])
        format.html { redirect_to @status, notice: t(:status_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @status.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /statuses/1
  # DELETE /statuses/1.json
  def destroy
    @status = Status.find(params[:id])
    @status.destroy

    respond_to do |format|
      format.html { redirect_to statuses_url }
      format.json { head :no_content }
    end
  end
end
