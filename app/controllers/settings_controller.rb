class SettingsController < ApplicationController
  
  # GET /settings
  def show    
    authorize! :view, :settings
    @statuses = Status.where(validity: true)
    @price_lists = PriceList.where(validity: true)
    @photo_width_res = [320,400,640,800,1024,1152,1280,1400,1440,1600,1680,1920,2048,2560,3200,3840]
    @photo_heigth_res = [240,480,600,768,864,900,1024,1050,1080,1152,1200,1536,1600,2048,2400]
    @photo_resolutions = ['320x240','400x240','640x240','640x480','800x480','800x600','1024x600',
                          '1024x768','1152x864','1280x768','1280x1024','1440x900','1600x900','1400x1050',
                          '1600x1024','1680x1050','1600x1200','1920x1080','1920x1200','2048x1536','2048x1152',
                          '2560x1600','2560x2048','3200x2048','3200x2400','3840x2400']
    if Settings.photo_width_res.present? and Settings.photo_height_res.present?
      @select_photo_resolution = Settings.photo_width_res + 'x' + Settings.photo_height_res
    end
  end
  
  # PUT /settings
  def update
    authorize! :manage, :settings
    @statuses = Status.where(validity: true)  
    @price_lists = PriceList.where(validity: true)
    @photo_width_res = [320,400,640,800,1024,1152,1280,1400,1440,1600,1680,1920,2048,2560,3200,3840]
    @photo_heigth_res = [240,480,600,768,864,900,1024,1050,1080,1152,1200,1536,1600,2048,2400]
    @photo_resolutions = ['320x240','400x240','640x240','640x480','800x480','800x600','1024x600',
                          '1024x768','1152x864','1280x768','1280x1024','1440x900','1600x900','1400x1050',
                          '1600x1024','1680x1050','1600x1200','1920x1080','1920x1200','2048x1536','2048x1152',
                          '2560x1600','2560x2048','3200x2048','3200x2400','3840x2400']
    if Settings.photo_width_res and Settings.photo_height_res
      @select_photo_resolution = Settings.photo_width_res + 'x' + Settings.photo_height_res
    end                       
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
    
    if params[:ftp_passive]
      config['ftp_passive'] = true
    else
      config['ftp_passive'] = false
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
    
    unless params[:default_route_point_attended_status_id].empty?
      config['default_route_point_attended_status_id'] = params[:default_route_point_attended_status_id]
    else
      error = t(:default_route_point_attended_status) + ' ' + t('errors.messages.blank') 
      @errors << error
    end  
    
    unless params[:default_price_list_id].empty?
      config['default_price_list_id'] = params[:default_price_list_id]
    else
      error = t(:default_price_list) + ' ' + t('errors.messages.blank') 
      @errors << error
    end      
     
    unless params[:order_filename].empty?
      config['order_filename'] = params[:order_filename]
    else
      error = t(:order_filename) + ' ' + t('errors.messages.blank') 
      @errors << error
    end   
    
    unless params[:email].empty?
      config['email'] = params[:email]
    else
      error = t(:email) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:mail_server].empty?
      config['mail_server'] = params[:mail_server]
    else
      error = t(:mail_server) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:smtp_port].empty?
      config['smtp_port'] = params[:smtp_port]
    else
      error = t(:smtp_port) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:mail_user].empty?
      config['mail_user'] = params[:mail_user]
    else
      error = t(:mail_user) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:mail_password].empty?
      config['mail_password'] = params[:mail_password]
    else
      error = t(:mail_password) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:server_name].empty?
      config['server_name'] = params[:server_name]
    else
      error = t(:server_name) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:server_port].empty?
      config['server_port'] = params[:server_port]
     else
      error = t(:server_port) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:upload_period].empty?
      config['upload_period'] = params[:upload_period]
     else
      error = t(:upload_period) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:photo_resolution].empty?
      photo_resolutions = params[:photo_resolution].split('x')
      config['photo_width_res'] = photo_resolutions[0]
      config['photo_height_res'] = photo_resolutions[1]
     else
      error = t(:photo_resolution) + ' ' + t('errors.messages.blank') 
      @errors << error
    end
    
    unless params[:message_pull_frequency].empty?
      config['message_pull_frequency'] = params[:message_pull_frequency]
     else
      error = t(:message_pull_frequency) + ' ' + t('errors.messages.blank') 
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
  
  # PUT /settings/crontab
  def update_crontab
    if system("cd #{Rails.root} && whenever --update-crontab mss --set environment=#{Rails.env} --roles db")
      redirect_to settings_path, notice: t(:crontab_updated)  
    else
      redirect_to settings_path, notice: t(:crontab_not_updated)
    end
    
  end
end
