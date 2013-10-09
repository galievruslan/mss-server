class UsersController < ApplicationController
  load_and_authorize_resource
    
  # GET /users
  # GET /users.json
  def index
    @search = User.search(params[:q])
    @users = @search.result.page(params[:page]).per(current_user.list_page_size)
    @managers = Manager.all
    @roles = Role.all
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
  
  # GET /users/new
  # GET /users/new.json  
  def new
    @user = User.new
    @managers = Manager.where(validity: true)
    @groups = Group.all
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @user }
    end
  end

  # GET /users/1/edit
  def edit
    @managers = Manager.where(validity: true)
    @groups = Group.all 
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
  
  # GET /users/1/edit_password
  def edit_password
    @user = User.find(params[:id])
  end
  
  # PUT /users/1/edit_password
  def update_password
    @user = User.find(params[:id])
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to users_path, notice: t(:password_updated) }
        format.json { render json: @user, status: :created, location: @user }
      else
        format.html { render action: "edit_password" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  
  # POST /users
  # POST /users.json
  def create
    @managers = Manager.where(validity: true)
    @groups = Group.all 
    @user = User.new(params[:user])    
    
    if params[:admin]
      @role_admin = true
    end
    if params[:supervisor]
      @role_supervisor = true
    end
    if params[:manager]
      @role_manager = true
    end 
    
    if !params[:manager] and !params[:supervisor] and !params[:admin]
      @user.errors.add(:role, t('errors.messages.must_be_selected'))
      render action: "new" 
      return
    end
    
    if params[:manager] and params[:user][:manager_id] == ""
      @user.errors.add(:manager_id, t('errors.messages.blank'))
      render action: "new" 
      return
    end     
         
    respond_to do |format|
      if @user.save
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
    @groups = Group.all
    @user = User.find(params[:id])
    
    if params[:admin]
      @role_admin = true
    end
    if params[:supervisor]
      @role_supervisor = true
    end
    if params[:manager]
      @role_manager = true
    end
    
    if !params[:manager] and !params[:supervisor] and !params[:admin]
      @user.errors.add(:role, t('errors.messages.must_be_selected'))
      render action: "new" 
      return
    end
    
    if params[:manager] and params[:user][:manager_id] == ""
      @user.errors.add(:manager_id, t('errors.messages.blank'))
      render action: "edit" 
      return
    end     
    
    respond_to do |format|
      if @user.update_attributes(params[:user])
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
        format.html { redirect_to users_path, notice: t(:user_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
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
    if params[:user_ids]
      if params[:operation]=='ban'
        params[:user_ids].each do |user_id|
          @user = User.find(user_id)
          if !@user.banned
            @user.update_attributes(banned: true)
          end
        end
        redirect_to users_url, notice: t(:users_banned)
      elsif params[:operation]=='remove'
        params[:user_ids].each do |user_id|
          @user = User.find(user_id)
          @user.destroy
        end
        redirect_to users_url, notice: t(:users_removed)
      end
    else
      redirect_to users_url
    end
  end
end
