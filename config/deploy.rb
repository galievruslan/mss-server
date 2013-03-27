require "rvm/capistrano"
require 'bundler/capistrano'

ssh_options[:forward_agent] = true
set :application, 'mss-server'
set :rvm_ruby_string, '1.9.3'
set :repository,  "git@github.com:galievruslan/mss-server.git" 
set :deploy_to, "/team/mss" 
set :deploy_via, :remote_cache
set :scm, 'git'
set :branch, 'master'
set :scm_verbose, true
set :use_sudo, false
set :rails_env, :production
set :default_stage, 'production'
set :normalize_asset_timestamps, false

namespace :deploy do
  desc "cause Passenger to initiate a restart"
  task :restart do
    run "touch #{current_path}/tmp/restart.txt" 
  end
  desc "reload the database with seed data"
  task :seed do
    run "cd #{current_path}; rake db:seed RAILS_ENV=#{rails_env}"
  end
end

server '192.168.3.109', :web, :app, :db, :primary => true