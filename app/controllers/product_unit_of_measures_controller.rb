class ProductUnitOfMeasuresController < ValidableModelController
  load_and_authorize_resource
  # GET /product_unit_of_measures
  # GET /product_unit_of_measures.json
  def index
    @product = Product.find(params[:product_id])
    if params[:q]
      @search = @product.product_unit_of_measures.search(params[:q])
      @product_unit_of_measures = @search.result.page(params[:page]).per(current_user.list_page_size)
    else
      @search = @product.product_unit_of_measures.search(params[:q])
      @product_unit_of_measures = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
    end
    
    @unit_of_measures = UnitOfMeasure.all
    # @product_unit_of_measures_json = @product.unit_of_measures
    @product_unit_of_measures_json = []
    @product.product_unit_of_measures.where(validity: true).each do |product_unit_of_measure|
      
        @product_unit_of_measure_json = {"name" => product_unit_of_measure.unit_of_measure.name, "id" => product_unit_of_measure.unit_of_measure_id, "base" => product_unit_of_measure.base }
      
        @product_unit_of_measures_json << @product_unit_of_measure_json
      
    end
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @product_unit_of_measures_json }
    end
  end

  # GET /product_unit_of_measures/1
  # GET /product_unit_of_measures/1.json
  def show
    @product = Product.find(params[:product_id])
    @product_unit_of_measure = ProductUnitOfMeasure.find(params[:id])
    
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product_unit_of_measure }
    end
  end

  # GET /product_unit_of_measures/new
  # GET /product_unit_of_measures/new.json
  def new
    @product = Product.find(params[:product_id])    
    @product_unit_of_measure = ProductUnitOfMeasure.new
    @unit_of_measures = UnitOfMeasure.where(validity: true)

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product_unit_of_measure }
    end
  end

  # GET /product_unit_of_measures/1/edit
  def edit    
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @product = Product.find(params[:product_id])
    @product_unit_of_measure = ProductUnitOfMeasure.find(params[:id])
  end

  # POST /product_unit_of_measures
  # POST /product_unit_of_measures.json
  def create
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @product = Product.find(params[:product_id])
    @product_unit_of_measure = ProductUnitOfMeasure.new(params[:product_unit_of_measure])
    @product.product_unit_of_measures << @product_unit_of_measure
    @product.save
    
    respond_to do |format|
      if @product_unit_of_measure.save
        format.html { redirect_to product_product_unit_of_measure_path(@product, @product_unit_of_measure), notice: t(:product_unit_of_measure_created) }
        format.json { render json: @product_unit_of_measure, status: :created, location: @product_unit_of_measure }
      else
        format.html { render action: "new" }
        format.json { render json: @product_unit_of_measure.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /product_unit_of_measures/1
  # PUT /product_unit_of_measures/1.json
  def update
    @unit_of_measures = UnitOfMeasure.where(validity: true)
    @product = Product.find(params[:product_id])
    @product_unit_of_measure = ProductUnitOfMeasure.find(params[:id])

    respond_to do |format|
      if @product_unit_of_measure.update_attributes(params[:product_unit_of_measure])
        format.html { redirect_to product_product_unit_of_measure_path(@product, @product_unit_of_measure), notice: t(:product_unit_of_measure_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product_unit_of_measure.errors, status: :unprocessable_entity }
      end
    end
  end
end
