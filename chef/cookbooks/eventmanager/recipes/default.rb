#
# Author:: Joshua Timberman <joshua@opscode.com>
# Author:: Daniel DeLeo <dan@kallistec.com>
# Cookbook Name:: eventmanager
# Recipe:: default
#
# Copyright 2009, Opscode, Inc.
# Copyright 2009, Daniel DeLeo
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

appname = "eventmanager"

include_recipe "git"
#include_recipe "mysql"
include_recipe "rails"
include_recipe "apache2"
include_recipe "apache2::mod_rewrite"
include_recipe "passenger_apache2::mod_rails"

#gem_package "mysql"

if eventmanager_edge?

  %w{config log pids system}.each do |dir|
    directory "/srv/#{appname}/shared/#{dir}" do
      recursive true
      owner "railsdev"
      group "railsdev"
      mode "0775"
    end
  end

  #template "/srv/#{appname}/shared/config/database.yml" do
  #  source "database.yml.erb"
  #  owner "railsdev"
  #  group "railsdev"
  #  variables :appname => appname
  #  mode "0664"
  #end

  #file "/srv/#{appname}/shared/sqlite/production.sqlite3" do
  #  owner "railsdev"
  #  group "railsdev"
  #  mode "0664"
  #end

  deploy "/srv/#{appname}" do
    repo "git@codaset.com:pdcmarques/event-manager.git"
    branch node[:eventmanager][:branch]
    user "railsdev"
    enable_submodules false
    migrate node[:eventmanager][:migrate]
    migration_command node[:eventmanager][:migrate_command]
    environment node[:eventmanager][:environment]
    shallow_clone true
    revision node[:eventmanager][:revision]
    action node[:eventmanager][:action].to_sym
    restart_command "touch tmp/restart.txt"
  end
else
  directory "/srv/#{appname}/current/" do
    recursive true
    owner "railsdev"
    group "railsdev"
    mode "0775"
  end

  #gem_package "radiant"

  #execute "radiant_generate" do
  #  command "radiant -d sqlite3 /srv/#{appname}/current/"
  #  creates "/srv/#{appname}/current/public"
  #  user "railsdev"
  #end
end

web_app "#{appname}" do
  docroot "/srv/#{appname}/current/public"
  template "#{appname}.conf.erb"
  server_name "#{appname}.#{node[:domain]}"
  server_aliases [ "#{appname}", node[:hostname] ]
  rails_env node[:eventmanager][:environment]
end
