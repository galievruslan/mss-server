class UsersController < ApplicationController
  load_and_authorize_resource  
  
  def index
    @search = User.search(params[:q])
    @users = @search.result.page(params[:page]).per(current_user.list_page_size)
    @managers = Manager.all
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @users }
    end
  end
  
  def show
    @user = User.find(params[:id])
    if @user.manager_id
      @manager = Manager.find(@user.manager_id)
    end    
  end

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
  
  def new
    @user = User.new
    @managers = Manager.where(validity: true) 
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

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

  def destroy
    @managers = Manager.where(validity: true) 
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to users_path, notice: t(:user_destroyed) }
      format.json { head :no_content }
    end
  end
end
