class ProfilesController < ApplicationController  
  
  def current    
    @user = current_user
    @manager = Manager.find(@user.manager_id)    
    respond_to do |format|
      format.html #show.html.erb
      format.json { render json: @user }               
    end
  end
end
