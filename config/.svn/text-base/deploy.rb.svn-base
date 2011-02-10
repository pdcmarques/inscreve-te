set :application, "eventmanager"
set :repository,  "--username pedromarques --password pdm49731 http://pedromarques.svn.beanstalkapp.com/project/"

# If you aren't deploying to /u/apps/#{application} on the target
# servers (which is the default), you can specify the actual location
# via the :deploy_to variable:
set :deploy_to, "/var/www/vhosts/inscreve-te.com.pt/httpdocs/#{application}"
set :user, "root"

after "deploy:update_code", "deploy:chown"

role :app, "inscreve-te.com.pt"
role :web, "inscreve-te.com.pt"
role :db,  "inscreve-te.com.pt", :primary => true

namespace :deploy do
  desc "Change owner"
  task :chown, :roles => :app do
    run "chown www-data:www-data -R #{deploy_to}"
  end
  desc "Restart Application"
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end

