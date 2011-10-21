# encoding: utf-8
require 'bundler/capistrano'

set :application, "deposit_harvard"
set :repository,  "git@github.com:arcturo/deposit-harvard.git"

set :scm, :git
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

set :user, 'deploy'
set :scm_verbose, true
set :deploy_to, "/var/www/html/harvard"
set :use_sudo, false

# Some things to try, mayhap
# set :deploy_via, :remote_cache

role :web, "173.230.135.96"
role :app, "173.230.135.96"
role :db,  "173.230.135.96", :primary => true # This is where Rails migrations will run

default_run_options[:pty] = true
ssh_options[:forward_agent] = true

# if you're still using the script/reaper helper you will need
# these http://github.com/rails/irs_process_scripts

# If you are using Passenger mod_rails uncomment this:
namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
end

#################### Delayed Job madness ####################################
# From @rbrant's tweet about http://gist.github.com/178397

after "deploy:stop", "delayed_job:stop"
after "deploy:start", "delayed_job:start"
after "deploy:restart", "delayed_job:restart"

namespace :delayed_job do
  desc "Stop the delayed_job process"
  task :stop, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=delayed_job script/delayed_job stop"
  end

  desc "Start the delayed_job process"
  task :start, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=delayed_job script/delayed_job start"
  end

  desc "Restart the delayed_job process"
  task :restart, :roles => :app do
    stop
    wait_for_process_to_end('delayed_job')
    start
  end

  desc "Check the status of the delayed_job process"
  task :status, :roles => :app do
    run "cd #{current_path}; RAILS_ENV=delayed_job script/delayed_job status"
  end
end

def wait_for_process_to_end(process_name)
  run "COUNT=1; until [ $COUNT -eq 0 ]; do COUNT=`ps -ef | grep -v 'ps -ef' | grep -v 'grep' | grep -i '#{process_name}'|wc -l` ; echo 'waiting for #{process_name} to end' ; sleep 2 ; done"
end

after "deploy:update_code", "config:copy_shared_configurations"

# Configuration Tasks
namespace :config do
  desc "copy shared configurations to current"
  task :copy_shared_configurations, :roles => [:app] do
    %w[database.yml].each do |f|
      run "ln -nsf #{shared_path}/config/#{f} #{release_path}/config/#{f}"
    end
  end
end

after "deploy:setup", "init:database_yml"
after "deploy:setup", "init:s3_yml"

namespace :init do

  desc "setting proper permissions for deploy user"
  task :set_permissions do
    sudo "chown -R deploy #{base_path}/#{application}"
  end

  desc "create mysql db"
  task :create_database do
    # create the database on setup
    set :admin_user, 'root'
    set :admin_pass, 'arcturian'
    set :admin_user, Capistrano::CLI.ui.ask("database user: ") unless exists?(:admin_user)
    set :admin_pass, Capistrano::CLI.password_prompt("database password: ") unless exists?(:admin_pass)
    run "echo 'CREATE DATABASE #{application}_production' | mysql -u #{admin_user} –password=#{admin_pass}"
  end

  desc "create database.yml"
  task :database_yml do
    set :db_user, Capistrano::CLI.ui.ask("database user: ")
    set :db_pass, Capistrano::CLI.password_prompt("database password: ")
    database_configuration = %(

login: &login
  adapter: mysql
  encoding: utf8
  username: #{db_user}
  password: #{db_pass}
  database: #{application}_prod
  pool: 20

production:
  <<: *login
  host: 64.238.252.222

staging:
  <<: *login
  reconnect: false
  host: 64.238.252.222
  socket: /tmp/mysql.sock

remote:
  <<: *login
  reconnect: false
  host: 64.238.252.222
  socket: /tmp/mysql.sock

delayed_job:
  <<: *login
  host: localhost

)
    run "mkdir -p #{shared_path}/config"
    put database_configuration, "#{shared_path}/config/database.yml"
  end
end
