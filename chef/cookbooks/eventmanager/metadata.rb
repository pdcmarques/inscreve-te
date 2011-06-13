maintainer        "Pedro Marques"
maintainer_email  "pdcmarques@gmail.com"
license           "Apache 2.0"
description       "Installs EventManager from Git repository"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version           "0.1.1"

recipe "eventmanager", "Installs EventManagerApp"

%w{ subversion git rails apache2 mysql passenger_apache2 apache2 }.each do |cb|
  depends cb
end

%w{ ubuntu debian }.each do |os|
  supports os
end

attribute "eventmanager/branch",
  :display_name => "EventManager Branch",
  :description => "Branch from Git to use",
  :default => "HEAD"

attribute "eventmanager/migrate",
  :display_name => "EventManager Migrate",
  :description => "Whether to do a migration",
  :default => "false"

attribute "eventmanager/migrate_command",
  :display_name => "EventManager Migrate Command",
  :description => "Command to perform migration",
  :default => "rake db:migrate"

attribute "eventmanager/environment",
  :display_name => "EventManager Environment",
  :description => "Rails environment to use",
  :default => "production"

attribute "eventmanager/revision",
  :display_name => "EventManager Revision",
  :description => "Revision to use from Git",
  :default => "HEAD"

attribute "eventmanager/action",
  :display_name => "EventManager Action",
  :description => "Whether to deploy the application or not",
  :default => "nothing"
