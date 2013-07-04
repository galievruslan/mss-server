config = YAML.load_file("#{Whenever.path}/config/settings.local.yml")

if !config['upload_period'].blank?
  upload_period = config['upload_period']
else
  upload_period = 5
end

set :job_template, "bash -l -i -c ':job'"

set :output, "/var/log/cron.log"
every upload_period.to_i.minutes do
  rake "exchange:send_orders_ftp"
end
every 1.day, :at => '2:30 am' do
  rake "exchange:upload_from_ftp"
end