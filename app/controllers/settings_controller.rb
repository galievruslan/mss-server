class SettingsController < ApplicationController
  
  # GET /settings
  def show
    authorize! :settings , :view 
    @config = YAML.load_file("#{Rails.root}/config/config.yml")[Rails.env]
  end
  
  # PUT /settings
  def update
    config = YAML.load_file("#{Rails.root}/config/config.yml")
    config[Rails.env]['ftp_server'] = params[:ftp_server]
    config[Rails.env]['ftp_user'] = params[:ftp_user]
    config[Rails.env]['ftp_password'] = params[:ftp_password]
    config[Rails.env]['ftp_inbox_directory'] = params[:ftp_inbox_directory]
    config[Rails.env]['ftp_outbox_directory'] = params[:ftp_outbox_directory]
    config[Rails.env]['default_route_point_status'] = params[:default_route_point_status]
    File.open("#{Rails.root}/config/config.yml", 'w') { |f| YAML.dump(config, f) }
    
    redirect_to settings_path, notice: t(:settings_updated)
  end
end
