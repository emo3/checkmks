#
# Cookbook:: checkmk
# Recipe:: default
#
# Copyright:: 2019, Ed Overton, Apache 2.0
# package %w(xinetd openssl python)

set_hostname 'chefsrv'
set_hostname 'websrv' do
  host_ip '10.1.1.30'
  host_name 'websrv'
end
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

execute "start_#{node['cmk']['instance_name']}" do
  command "omd start #{node['cmk']['instance_name']}"
  not_if ("ps -eaf | grep -v grep | grep #{node['cmk']['instance_name']}")
end

execute 'fix for selinux' do
  command '/usr/sbin/setsebool -P httpd_can_network_connect=1'
  only_if ('/usr/sbin/getsebool httpd_can_network_connect | grep off')
end

execute 'automation-key' do
  command 'cat /opt/omd/sites/cmk/var/check_mk/web/automation/automation.secret'
  live_stream true
  action :run
end
