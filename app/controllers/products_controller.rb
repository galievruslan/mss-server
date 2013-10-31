class ProductsController < ValidableModelController
  load_and_authorize_resource :except => :unit_of_measures
  # GET /products
  # GET /products.json
  def index
    if params[:category_id]
      if params[:q]
        @search = Product.where(category_id: params[:category_id]).search(params[:q])
        @products = @search.result.page(params[:page]).per(current_user.list_page_size)
      else
        @search = Product.where(category_id: params[:category_id]).search(params[:q])    
        @products = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
      end 
    else
      if params[:q]
        @search = Product.search(params[:q])
        @products = @search.result.page(params[:page]).per(current_user.list_page_size)
      else
        @search = Product.search(params[:q])    
        @products = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)
      end 
    end     
    
    @categories = Category.all
        
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @products }
    end
  end

  # GET /products/1
  # GET /products/1.json
  def show
    @product = Product.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/new
  # GET /products/new.json
  def new
    @categories = Category.where(validity: true)
    @product = Product.new
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @product }
    end
  end

  # GET /products/1/edit
  def edit
    @categories = Category.where(validity: true)
    @product = Product.find(params[:id])
  end

  # POST /products
  # POST /products.json
  def create
    @product = Product.new(params[:product])

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: t(:product_created) }
        format.json { render json: @product, status: :created, location: @product }
      else
        format.html { render action: "new" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /products/1
  # PUT /products/1.json
  def update
    @product = Product.find(params[:id])

    respond_to do |format|
      if @product.update_attributes(params[:product])
        format.html { redirect_to @product, notice: t(:product_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end
  
  #GET /products/:id/unit_of_measures/:unit_of_measure_id
  def unit_of_measures
    respond_to do |format|
      @unit_of_measure = ProductUnitOfMeasure.find_by_product_id_and_unit_of_measure_id(params[:id], params[:unit_of_measure_id]) 
      format.json { render json: @unit_of_measure }
    end
  end
end
