current_dir = File.dirname(__FILE__)
log_level                :info
log_location             STDOUT
node_name                "pdcmarques"
client_key               "#{current_dir}/pdcmarques.pem"
validation_client_name   "inscreve-te-validator"
validation_key           "#{current_dir}/inscreve-te-validator.pem"
chef_server_url          "https://api.opscode.com/organizations/inscreve-te"
cache_type               'BasicFile'
cache_options( :path => "#{ENV['HOME']}/.chef/checksums" )
cookbook_path            ["#{current_dir}/../cookbooks"]

knife[:aws_access_key_id] = "13Y7V25GRYQS7FBRV1R2"
knife[:aws_secret_access_key] =  "BmGObsWvAD0ku37yQLA1ISQmmfRWHxF8IZ6QzkLt"
