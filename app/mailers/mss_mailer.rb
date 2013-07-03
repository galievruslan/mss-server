class MssMailer < Devise::Mailer   
  default from: Settings.email  
  MssMailer.smtp_settings = {
    user_name: Settings.mail_user,
    password: Settings.mail_password,
    address: Settings.mail_server,
    port: Settings.smtp_port,
    authentication: 'plain'
  }
  MssMailer.default_url_options = {
    host: "#{Settings.server_name}:#{Settings.server_port}"
  }
  def confirmation_instructions(record, opts={})    
    super
  end

  def reset_password_instructions(record, opts={})
    super
  end

  def unlock_instructions(record, opts={})
    super
  end    
end
