require 'bundler/capistrano'

set :application, "Deposit@Harvard"
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
