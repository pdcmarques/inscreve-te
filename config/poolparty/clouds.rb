pool "inscrevete" do
    #user "ubuntu"
    cloud "app" do
      instances 1..4
      using :ec2
      
      user "ubuntu"
      
      availability_zones ['us-east-1d']
      image_id "ami-88f504e1"
      
      chef :solo do
        repo File.dirname(__FILE__)+"/../cookbooks"
        recipe "rails"
        #recipe "passenger_apache2"
        #attributes :apache2 => {:listen_ports => ["80"]}
        
        #recipe "mysql::server"
        #recipe "mysql::server_ec2"
        
        
        #web_app "inscrevete" do 
        #  docroot "/var/www/inscrevete/public" 
        #  template "inscrevete.conf.erb" 
        #  server_name "www.inscrevete.com.pt" 
        #  server_aliases [node[:hostname], node[:fqdn], "inscrevete.com.pt"] 
        #  rails_env "production" 
        #end 
      end
    
      
      security_group do
        authorize :from_port => "22", :to_port => "22"
        authorize :from_port => "80", :to_port => "80"
      end
    end
  end
