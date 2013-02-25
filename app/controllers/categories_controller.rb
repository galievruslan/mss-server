class CategoriesController < ApplicationController
  load_and_authorize_resource
  # GET /categories
  # GET /categories.json
  def index
    
    @search = Category.search(params[:q])
    @categories = @search.result.page(params[:page]).per(current_user.list_page_size)
    
    if params[:page_size]
      page_size = params[:page_size]
    else
      page_size = 100
    end
    
    if params[:updated_at]
      @categories_json = Category.where("updated_at >= #{params[:updated_at]}").page(params[:page]).per(page_size)
    else
      @categories_json = Category.page(params[:page]).per(page_size)
    end 

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @categories_json }
    end
  end

  # GET /categories/1
  # GET /categories/1.json
  def show
    @category = Category.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/new
  # GET /categories/new.json
  def new
    @categories = Category.all
    @category = Category.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @category }
    end
  end

  # GET /categories/1/edit
  def edit
    @categories = Category.all
    @category = Category.find(params[:id])
  end

  # POST /categories
  # POST /categories.json
  def create
    @categories = Category.all
    @category = Category.new(params[:category])

    respond_to do |format|
      if @category.save
        format.html { redirect_to @category, notice: 'Category was successfully created.' }
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
        format.html { redirect_to @category, notice: 'Category was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @category.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /categories/1
  # DELETE /categories/1.json
  def destroy
    @category = Category.find(params[:id])
    if @category.validity 
      @category.update_attributes(validity: false)
    else
      @category.update_attributes(validity: true)
    end
    
    respond_to do |format|
      format.html { redirect_to categories_url }
      format.json { head :no_content }
    end
  end
end
