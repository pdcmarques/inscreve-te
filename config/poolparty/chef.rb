#include_recipe "mysql::server"

#web_app sets up passenger and theapache virtual host
web_app "inscrevete" do
  docroot "/var/www/inscrevete/current/public"
  template "inscrevete.conf.erb"
  server_name "inscreve-te.com.pt"
  server_aliases [node[:hostname], node[:fqdn], node[:ec2][:public_hostname]]
  rails_env "production"  
end
