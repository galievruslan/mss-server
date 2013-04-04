set :output, "/var/log/cron.log"
every 15.minutes do
  command "echo 'test'"
end