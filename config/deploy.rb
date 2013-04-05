require 'rvm/capistrano'
require 'bundler/capistrano'
require "whenever/capistrano"

# APPLICATION DETAILS #######################################
set :application, "mss"
set :deploy_to, "/var/www/#{application}"
set :rails_env, "production"
set :rvm_ruby_string, '1.9.3'
set :rvm_type, :system
set :normalize_asset_timestamps, false

# GETTING INTO THE PRODUCTION SERVER ########################
set :user, "deploy"
set :use_sudo, false
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

before 'deploy:assets:precompile', 'deploy:symlink_db', 'deploy:symlink_config','create_tmp_orders'
after "deploy:restart", "deploy:cleanup"

# TASKS #####################################################
namespace :deploy do
  desc "Restarting the app"  
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  desc "reloadthe database with seed data" 
    task :seed do
    run "cd # {current_path}; rake db:seed RAILS_ENV = #{rails_env}"
  end
  desc "Symlinks the database.yml"
  task :symlink_db do
    run "rm -f #{current_release}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end
  desc "Symlinks the config.yml"
  task :symlink_config do
    run "rm -f #{current_release}/config/config.yml"
    run "ln -nfs #{deploy_to}/shared/config/config.yml #{release_path}/config/config.yml"
  end
  desc "Create tmp orders folder"
  task :create_tmp_orders do
    run "mkdir #{release_path}/tmp/orders"
  end
end