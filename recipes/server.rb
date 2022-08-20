#
# Cookbook:: checkmks
# Recipe:: default
#
# Copyright:: 2019, Ed Overton, Apache 2.0

yum_repository 'almalinux-powertools' do
  description 'AlmaLinux $releasever - PowerTools'
  mirrorlist 'https://mirrors.almalinux.org/mirrorlist/$releasever/powertools'
  enabled true
  gpgcheck true
  gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-AlmaLinux'
  action :create
end

package %w(epel-release xinetd openssl python3 graphviz-gd)

# Download the check_mk raw server package file
log node['cmk']['media_url']
log node['cmk']['server_rpm']
remote_file "#{Chef::Config[:file_cache_path]}/#{node['cmk']['server_rpm']}" do
  source "#{node['cmk']['media_url']}/#{node['cmk']['server_rpm']}"
  mode '0444'
  action :create
end

package node['cmk']['server_rpm'] do
  source "#{Chef::Config[:file_cache_path]}/#{node['cmk']['server_rpm']}"
end

execute "create_#{node['cmk']['site_name']}" do
  command "omd create --admin-password #{node['cmk']['admin_passwd']} #{node['cmk']['site_name']}"
  sensitive true
  not_if { ::File.exist?("/opt/omd/sites/#{node['cmk']['site_name']}") }
  notifies :run, "execute[start_#{node['cmk']['site_name']}]", :immediately
end

execute "start_#{node['cmk']['site_name']}" do
  command "omd start #{node['cmk']['site_name']}"
  action :nothing
end

cookbook_file '/tmp/cat_token.sh' do
  source 'cat_token.sh'
  mode '0755'
end
