class ApplicationController < ActionController::Base
  
  #check_authorization
  protect_from_forgery
  before_filter :set_language_from_current_user
  before_filter :banned?
  before_filter :authenticate_user!
  
  
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end
  
  layout :layout
  
  private
    before_filter :instantiate_controller_and_action_names
   
  def instantiate_controller_and_action_names
      @current_action = action_name
      @current_controller = controller_name
  end  
  
  def set_language_from_current_user
    if current_user and current_user.language == 'RU'
      I18n.default_locale = :ru
      I18n.locale = :ru 
    elsif current_user and current_user.language == 'EN'
      I18n.default_locale = :en
      I18n.locale = :en 
    else
      I18n.default_locale = :ru
      I18n.locale = :ru
    end   
  end
    
  def layout
    if devise_controller? && devise_mapping.name == :user
      "logon"
    else
      "application"
    end
  end    

  def banned?
    if current_user.present? && current_user.banned?
      sign_out current_user
      flash[:error] = t(:user_banned)
      root_path
    end
  end
end
