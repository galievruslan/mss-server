class UnitOfMeasuresController < ApplicationController
  load_and_authorize_resource
  # GET /unit_of_measures
  # GET /unit_of_measures.json
  def index
    if params[:q]
      @search = UnitOfMeasure.search(params[:q])
      @unit_of_measures = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = UnitOfMeasure.search(params[:q])    
      @unit_of_measures = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @unit_of_measures }
    end
  end

  # GET /unit_of_measures/1
  # GET /unit_of_measures/1.json
  def show
    @unit_of_measure = UnitOfMeasure.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @unit_of_measure }
    end
  end

  # GET /unit_of_measures/new
  # GET /unit_of_measures/new.json
  def new
    @unit_of_measure = UnitOfMeasure.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @unit_of_measure }
    end
  end

  # GET /unit_of_measures/1/edit
  def edit
    @unit_of_measure = UnitOfMeasure.find(params[:id])
  end

  # POST /unit_of_measures
  # POST /unit_of_measures.json
  def create
    @unit_of_measure = UnitOfMeasure.new(params[:unit_of_measure])

    respond_to do |format|
      if @unit_of_measure.save
        format.html { redirect_to @unit_of_measure, notice: t(:unit_of_measure_created) }
        format.json { render json: @unit_of_measure, status: :created, location: @unit_of_measure }
      else
        format.html { render action: "new" }
        format.json { render json: @unit_of_measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /unit_of_measures/1
  # PUT /unit_of_measures/1.json
  def update
    @unit_of_measure = UnitOfMeasure.find(params[:id])

    respond_to do |format|
      if @unit_of_measure.update_attributes(params[:unit_of_measure])
        format.html { redirect_to @unit_of_measure, notice: t(:unit_of_measure_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @unit_of_measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /unit_of_measures/1
  # DELETE /unit_of_measures/1.json
  def destroy
    @unit_of_measure = UnitOfMeasure.find(params[:id])
    if @unit_of_measure.validity 
      @unit_of_measure.update_attributes(validity: false)
    else
      @unit_of_measure.update_attributes(validity: true)
    end

    respond_to do |format|
      format.html { redirect_to unit_of_measures_url }
      format.json { head :no_content }
    end
  end
end
