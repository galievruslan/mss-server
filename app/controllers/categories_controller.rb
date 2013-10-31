class CategoriesController < ValidableModelController
  load_and_authorize_resource
  # GET /categories
  # GET /categories.json
  def index
    if params[:q]
      @search = Category.search(params[:q])
      @categories = @search.result.page(params[:page]).per(current_user.list_page_size)
    else  
      @search = Category.search(params[:q])    
      @categories = @search.result.where(validity: true).page(params[:page]).per(current_user.list_page_size)      
    end
    @products_count = Product.where(validity: true).count(:group=>:category_id)
    @parents = Category.all    

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = Category.find(params[:id])
    @search = @category.products.search(params[:q])
    @products = @search.result.page(params[:page]).per(current_user.list_page_size)
    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @categories = Category.where(validity: true)
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @categories = Category.where(validity: true)
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  def create
    @categories = Category.where(validity: true)
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: t(:category_created) }
        format.json { render json: @category, status: :created, location: @category }
      else
        format.html { render action: "new" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /categories/1
  # PUT /categories/1.json
  def update
    @category = Category.find(params[:id])

    respond_to do |format|
      if @category.update_attributes(params[:category])
        format.html { redirect_to @category, notice: t(:category_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end
end
