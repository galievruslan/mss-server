class ProfilesController < ApplicationController  
  # GET /profile/show
  # GET /profile/show.json  
  def show    
    @user = current_user
    if @user.manager_id
      @manager = Manager.find(@user.manager_id)
    end      
    respond_to do |format|
      format.html #show.html.erb
      format.json { render json: @user }               
    end
  end
  # GET /profile/edit  
  def edit
    @user = current_user
  end
  
  def edit_password
    @user = current_user
  end
  
      
  def update_password
    @user = current_user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to profile_show_path, notice: t(:password_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
  # PUT /profile/update
  # GET /profile/update.json  
  def update
    @user = current_user
    respond_to do |format|
      if @user.update_attributes(params[:user])
        format.html { redirect_to profile_show_path, notice: t(:profile_updated) }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end
end
