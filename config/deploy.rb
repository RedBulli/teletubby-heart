set :rvm_type, :user

require "rvm/capistrano"
require 'capistrano/ext/multistage'
require "bundler/capistrano"
load "deploy/assets"
default_run_options[:pty] = true
set :use_sudo, false
set :stages, ["test_server", "production"]
set :default_stage, "test_server"

set :application, "Teletubby Heart"
set :repository,  "git@github.com:avaus/teletubby-heart.git"

set :branch, "master"

#set :rvm_ruby_string, :local
#set :rvm_ruby_string, "1.9.3-p286"

set :scm, :git

after "deploy", "deploy:migrate"
after "deploy:restart", "deploy:cleanup"
before "deploy:assets:precompile" do
 run "ln -nfs #{deploy_to}/shared/config/database.yml #{release_path}/config/database.yml"
end

# Faye worker
set(:faye_pid) { "#{deploy_to}/current/tmp/pids/faye.pid" }
set(:faye_config) { "#{deploy_to}/current/private_pub.ru" }
namespace :faye do
  desc "Start Faye"
  task :start do
    run "cd #{release_path}/ && bundle exec rackup #{faye_config} -s thin -E production -D --pid #{faye_pid} -p #{faye_port}"
  end
  desc "Stop Faye"
  task :stop do
    run "kill `cat #{faye_pid}` || true"
  end
end
before 'deploy:update_code', 'faye:stop'
after 'deploy:finalize_update', 'faye:start'

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end
