include_recipe "apache2" 
include_recipe "passenger" 
include_recipe "rails" 
include_recipe "git" 
include_recipe "ec2" 
include_recipe "mysql"
include_recipe "haproxy"
include_recipe "monit"

web_app "inscrevete" do 
   docroot "/var/www/inscrevete/public" 
   template "inscrevete.conf.erb" 
   server_name "www.inscrevete.com.pt" 
   server_aliases [node[:hostname], node[:fqdn], "inscrevete.com.pt"] 
   rails_env "production" 
end 