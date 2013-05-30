namespace :exchange do
  desc 'Send not exported orders to FTP server'
  task :send_orders_ftp => :environment do
    exchange = ExchangeController.new
    exchange.send_to_ftp_cron
  end
  
  desc 'Send not exported orders to FTP server'
  task :upload_from_ftp => :environment do
    exchange = ExchangeController.new
    exchange.upload_from_ftp
  end
end
