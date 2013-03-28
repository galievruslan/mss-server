require 'rvm/capistrano'
require 'bundler/capistrano'

# APPLICATION DETAILS #######################################
set :application, "mss"
set :deploy_to, "/var/www/#{application}"
set :rails_env, "production"
set :rvm_ruby_string, '1.9.3@mss'

# GETTING INTO THE PRODUCTION SERVER ########################
set :user, "deploy"
set :use_sudo, false
ssh_options[:paranoid] = false 
set :domain, "192.168.3.109"
role :app, domain
role :web, domain
role :db, domain, :primary => true

# GIT AND GITHUB ############################################
set :scm, :git
set :repository,  "git@github.com:galievruslan/mss-server.git"
set :branch, "master"
set :scm_command, "/usr/bin/git"
set :deploy_via, :remote_cache

before 'deploy:setup', 'rvm:install_rvm', 'rvm:install_ruby'
after "deploy:update_code","deploy:restart"

# TASKS #####################################################
namespace :deploy do
  desc "Restarting the app"  
  task :restart do
    run "touch #{shared_path}/tmp/restart.txt"
  end
end