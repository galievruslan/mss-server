class UsersController < ApplicationController
  load_and_authorize_resource
    
  # GET /users
  # GET /users.json
  def index
    @search = User.search(params[:q])
    @users = @search.result.page(params[:page]).per(current_user.list_page_size)
    @managers = Manager.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
  
  # GET /users/1
  # GET /users/1.json  
  def show
    @user = User.find(params[:id])
    if @user.manager_id
      @manager = Manager.find(@user.manager_id)
    end    
  end

  # GET /users/1/edit
  def edit
    @managers = Manager.where(validity: true) 
    @user = User.find(params[:id])
    @user.roles.each do |role|
      case role.name
      when 'admin'
        @role_admin = true
      when 'supervisor'
        @role_supervisor = true
      when 'manager'
        @role_manager = true
      end      
    end
  end
  
  # GET /users/new
  # GET /users/new.json  
  def new
    @user = User.new
    @managers = Manager.where(validity: true) 
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # POST /users
  # POST /users.json
  def create
    @managers = Manager.where(validity: true) 
    @user = User.new(params[:user])
    @user.save
    
    if params[:admin]
      role = Role.find_by_name('admin')
      @user.roles << role
    end
    if params[:supervisor]
      role = Role.find_by_name('supervisor')
      @user.roles << role
    end
    if params[:manager]
      role = Role.find_by_name('manager')
      @user.roles << role
    end
             
    respond_to do |format|
      if @user.save
        format.html { redirect_to users_path, notice: t(:user_created) }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "new" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.json  
  def update
    @managers = Manager.where(validity: true) 
    @user = User.find(params[:id])
    @user.roles.delete_all
    if params[:admin]
      role = Role.find_by_name('admin')
      @user.roles << role
    end
    if params[:supervisor]
      role = Role.find_by_name('supervisor')
      @user.roles << role
    end
    if params[:manager]
      role = Role.find_by_name('manager')
      @user.roles << role
    end
    @user.save
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_path, notice: t(:user_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user1.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @managers = Manager.where(validity: true) 
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_path, notice: t(:user_destroyed) }
      format.json { head :no_content }
    end
  end
  
  # POST /users/multiple_change
  def multiple_change
    params[:user_ids].each do |user_id|
      @user = User.find(user_id)
      if !@user.banned
        @user.update_attributes(banned: true)
      end
    end
    respond_to do |format|
      format.html { redirect_to users_url, notice: t(:users_banned) }
      format.json { head :no_content }
    end
  end
end
