namespace :exchange do
  desc 'Send not exported orders to FTP server'
  task :send_orders_ftp => :environment do
    exchange = ExchangeController.new
    exchange.send_to_ftp_cron
  end
end
