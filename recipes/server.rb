#
# Cookbook:: checkmk
# Recipe:: default
#
# Copyright:: 2019, Ed Overton, Apache 2.0
# package %w(xinetd openssl python)

epel_local_repo 'checkmk'

# Download the check_mk raw server package file
remote_file "#{Chef::Config[:file_cache_path]}/#{node['cmk']['server_rpm']}" do
  source "#{node['cmk']['media_url']}/#{node['cmk']['server_rpm']}"
  mode '0444'
  action :create
end

package node['cmk']['server_rpm'] do
  source "#{Chef::Config[:file_cache_path]}/#{node['cmk']['server_rpm']}"
end

execute "create_#{node['cmk']['instance_name']}" do
  command "omd create --admin-password #{node['cmk']['admin_passwd']} #{node['cmk']['instance_name']}"
  sensitive true
  not_if { File.exist?("/opt/omd/sites/#{node['cmk']['instance_name']}") }
end

## TODO
# service "apache" do
#   supports :status => true, :restart => true, :start => true
#   action [ :start ]
# end

execute "start_#{node['cmk']['instance_name']}" do
  command "omd start #{node['cmk']['instance_name']}"
  not_if ("ps -eaf | grep -v grep | grep #{node['cmk']['instance_name']}")
end

# execute 'change passwd' do
#   command "su - sandbox -c 'htpasswd -b -m ~/etc/htpasswd cmkadmin cmkadmin'"
#   # returns [0, 1, 2]
# end

execute 'fix for selinux' do
  command '/usr/sbin/setsebool -P httpd_can_network_connect=1'
  only_if ('/usr/sbin/getsebool httpd_can_network_connect | grep off')
end
