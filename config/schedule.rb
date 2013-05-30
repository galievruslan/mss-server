# config = YAML.load_file("#{Whenever.path}/config/settings.local.yml")
# period = config['export_orders_ftp_period']
set :job_template, "bash -l -i -c ':job'"
set :output, "/var/log/cron.log"
every 5.minutes do
  rake "exchange:send_orders_ftp"
end
every 1.day, :at => '2:30 am' do
  rake "exchange:upload_from_ftp"
end