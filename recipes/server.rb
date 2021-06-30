#
# Cookbook:: checkmk
# Recipe:: default
#
# Copyright:: 2019, Ed Overton, Apache 2.0
# package %w(xinetd openssl python)

package 'epel-release'

replace_or_add 'enablePowerTools' do
  path '/etc/yum.repos.d/CentOS-Linux-PowerTools.repo'
  pattern 'enabled=0'
  line 'enabled=1'
end

if node['cmk']['local_url'] != 'y'
  node.default['cmk']['media_url'] = "https://download.checkmk.com/checkmk/#{node['cmk']['cmk_release']}"
else
  append_if_no_line 'chefsrv' do
    path '/etc/hosts'
    line '10.1.1.10 chefsrv'
  end

  append_if_no_line 'websrv' do
    path '/etc/hosts'
    line '10.1.1.30 websrv'
  end
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

execute "create_#{node['cmk']['site_name']}" do
  command "omd create --admin-password #{node['cmk']['admin_passwd']} #{node['cmk']['site_name']}"
  sensitive true
  not_if { ::File.exist?("/opt/omd/sites/#{node['cmk']['site_name']}") }
end

execute "start_#{node['cmk']['site_name']}" do
  command "omd start #{node['cmk']['site_name']}"
  not_if("ps -eaf | grep -v grep | grep #{node['cmk']['site_name']}")
end

cookbook_file '/tmp/cat_token.sh' do
  source 'cat_token.sh'
  mode '0755'
end
