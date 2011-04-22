require 'mongrel_cluster/recipes'
set :application, "newzatsadmin"
set :repository,  "git@github.com:gregrogan/newzats-admin.git"

set :scm, "git"

set :user, "deploy"
# Or: `accurev`, `bzr`, `cvs`, `darcs`, `git`, `mercurial`, `perforce`, `subversion` or `none`

ssh_options[:forward_agent] = true

set :branch, "master"

role :web, "newzatsadmin.gregrogan.com"                          # Your HTTP server, Apache/etc
role :app, "newzatsadmin.gregrogan.com"                          # This may be the same as your `Web` server
role :db,  "newzatsadmin.gregrogan.com", :primary => true # This is where Rails migrations will run

set :deploy_to, "/var/apps/#{application}"
set :mongrel_conf, "#{current_path}/config/mongrel_cluster.yml"
#role :db,  "your slave db-server here"

# If you are using Passenger mod_rails uncomment this:
# if you're still using the script/reapear helper you will need
# these http://github.com/rails/irs_process_scripts

# namespace :deploy do
#   task :start {}
#   task :stop {}
#   task :restart, :roles => :app, :except => { :no_release => true } do
#     run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
#   end
# end

deploy.task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
end

