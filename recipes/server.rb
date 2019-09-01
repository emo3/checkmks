#
# Cookbook:: checkmk
# Recipe:: default
#
# Copyright:: 2019, Ed Overton, Apache 2.0
# package %w(xinetd openssl python)

epel_local_repo 'my epel' do
  not_if { File.exist?('/etc/yum.repo.d/epel7.repo') }
end

# Download the check_mk raw server package file
remote_file "#{Chef::Config[:file_cache_path]}/#{node['cmk']['server_rpm']}" do
  source "#{node['cmk']['media_url']}/#{node['cmk']['server_rpm']}"
  mode '0444'
  action :create
end

package node['cmk']['server_rpm'] do
 source "#{Chef::Config[:file_cache_path]}/#{node['cmk']['server_rpm']}"
end

# execute 'create_sandbox' do
#   command 'omd create sandbox'
#   not_if { File.exist?('/opt/omd/sites/sandbox') }
# end
#
# execute 'start sandbox' do
#   command 'omd start sandbox'
#   not_if ('ps -eaf | grep -v grep | grep sandbox')
#   returns [0, 1, 2]
# end
#
# execute 'change passwd' do
#   command "su - sandbox -c 'htpasswd -b -m ~/etc/htpasswd cmkadmin cmkadmin'"
#   # returns [0, 1, 2]
# end
#
# execute 'fix for selinux' do
#   command '/usr/sbin/setsebool -P httpd_can_network_connect=1'
#   # returns [0, 1, 2]
# end
