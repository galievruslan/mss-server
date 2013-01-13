class ApplicationController < ActionController::Base
  before_filter :authenticate_user!
  #check_authorization
  protect_from_forgery
  
  rescue_from CanCan::AccessDenied do |exception|
    flash[:error] = exception.message
    redirect_to root_url, :alert => exception.message
  end
  
  layout :layout
  
  private
    before_filter :instantiate_controller_and_action_names
   
    def instantiate_controller_and_action_names
        @current_action = action_name
        @current_controller = controller_name
    end
    
  def layout
    if devise_controller? && devise_mapping.name == :user
      "logon"
    else
      "application"
    end
  end  
   
end
