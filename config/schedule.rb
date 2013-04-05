set :output, "/var/log/cron.log"
every 1.minutes do
  command "wget http://192.168.3.108:3000/exchange/send_to_ftp"
end