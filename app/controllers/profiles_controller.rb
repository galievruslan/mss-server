class ProfilesController < ApplicationController  
  
  def current    
    @user = current_user
    if @user.manager_id
      @manager = Manager.find(@user.manager_id)
    end      
    respond_to do |format|
      format.html #show.html.erb
      format.json { render json: @user }               
    end
  end
end
