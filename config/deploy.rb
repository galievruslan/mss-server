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

before 'deploy:assets:precompile', 'deploy:symlink_db', 'deploy:symlink_config', 'deploy:create_folders'
after "deploy:restart", "deploy:cleanup"

# TASKS #####################################################
namespace :deploy do
  desc "Restarting the app"  
  task :restart do
    run "touch #{current_path}/tmp/restart.txt"
  end
  
  desc "Symlinks the database.yml"
  task :symlink_db do
    run "rm -f #{current_release}/config/database.yml"
    run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
  end  
  desc "Symlinks the settings.local.yml"
  task :symlink_config do
    run "rm -f #{current_release}/config/settings.local.yml"
    run "ln -nfs #{deploy_to}/shared/config/settings.local.yml #{release_path}/config/settings.local.yml"
  end
  
  desc "Create tmp orders folder and mobile clients folders"
  task :create_folders do
    run "mkdir #{release_path}/tmp/orders"
    run "mkdir #{release_path}/public/mobile_clients"
    run "mkdir #{release_path}/public/mobile_clients/android"
    run "mkdir #{release_path}/public/mobile_clients/winmobile"
  end
end

namespace :db do
  
    desc "Migrate Production Database"
    task :migrate do
      puts "\n\n=== Migrating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:migrate RAILS_ENV=production"
    end
 
    desc "Resets the Production Database"
    task :migrate_reset do
      puts "\n\n=== Resetting the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:migrate:reset RAILS_ENV=production"
    end
    
    desc "Destroys Production Database"
    task :drop do
      puts "\n\n=== Destroying the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:drop RAILS_ENV=production"
    end
  
    desc "Populates the Production Database"
    task :seed do
      puts "\n\n=== Populating the Production Database! ===\n\n"
      run "cd #{current_path}; rake db:seed RAILS_ENV=production"
    end
  
  end