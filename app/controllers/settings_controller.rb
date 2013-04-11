class SettingsController < ApplicationController
  
  # GET /settings
  def show    
    authorize! :settings , :view    
    @statuses = Status.all
  end
  
  # PUT /settings
  def update
    authorize! :settings , :manage
    @statuses = Status.all    
    @errors = []
    # Settings.ftp_server = params[:ftp_server]
    config = YAML.load_file("#{Rails.root}/config/settings.local.yml")
    
    unless params[:ftp_server].empty?
      config['ftp_server'] = params[:ftp_server]
    else
      error = t(:ftp_server) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:ftp_user].empty?
      config['ftp_user'] = params[:ftp_user]
    else
      error = t(:ftp_user) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:ftp_password].empty?
      config['ftp_password'] = params[:ftp_password]
    else
      error = t(:ftp_password) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:ftp_inbox_directory].empty?
      config['ftp_inbox_directory'] = params[:ftp_inbox_directory]
    else
      error = t(:ftp_inbox_directory) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:ftp_outbox_directory].empty?
      config['ftp_outbox_directory'] = params[:ftp_outbox_directory]
    else
      error = t(:ftp_inbox_directory) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:default_route_point_status_id].empty?
      config['default_route_point_status_id'] = params[:default_route_point_status_id]
    else
      error = t(:default_route_point_status) + ' ' + t('errors.messages.blank') 
      @errors << error
    end       
    
    if @errors.count == 0
      File.open("#{Rails.root}/config/settings.local.yml", 'w') { |f| YAML.dump(config, f) }
      Settings.reload!
      redirect_to settings_path, notice: t(:settings_updated)   
    else
      render action: "show"       
    end    
  end
end
