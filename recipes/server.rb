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
end if platform?('almalinux')

package %w(epel-release)
package %w(openssl httpie graphviz-gd)
# package %w(xinetd openssl httpie graphviz-gd)

# Download the check_mk raw server package file
remote_file "#{Chef::Config[:file_cache_path]}/#{node['cmk']['server_rpm']}" do
  source "#{node['cmk']['media_url']}/#{node['cmk']['server_rpm']}"
  mode '0444'
  action :create
end

package node['cmk']['server_rpm'] do
  source "#{Chef::Config[:file_cache_path]}/#{node['cmk']['server_rpm']}"
end

# See if this is a upgrade
execute "stop_#{node['cmk']['site_name']}" do
  command "omd stop #{node['cmk']['site_name']}"
  only_if "omd version|grep 'OMD - Open Monitoring Distribution Version #{node['cmk']['server_version']}'"
  notifies :run, "execute[upgrade_#{node['cmk']['site_name']}]", :immediately
  notifies :run, "execute[start_#{node['cmk']['site_name']}]", :immediately
  action :nothing
end

execute "create_#{node['cmk']['site_name']}" do
  command "omd create --admin-password #{node['cmk']['admin_passwd']} #{node['cmk']['site_name']}"
  sensitive true
  not_if { ::File.exist?("/opt/omd/sites/#{node['cmk']['site_name']}") }
  notifies :run, "execute[start_#{node['cmk']['site_name']}]", :immediately
end

execute "upgrade_#{node['cmk']['site_name']}" do
  command "omd setversion #{node['cmk']['cmk_release']}"
  action :nothing
end

execute "upgrade_#{node['cmk']['site_name']}" do
  command "omd start #{node['cmk']['site_name']}"
  action :nothing
end

execute "start_#{node['cmk']['site_name']}" do
  command "omd start #{node['cmk']['site_name']}"
  action :nothing
end

# Create file from template
template '/tmp/activate-checkmks.py' do
  source 'activate-checkmks1.erb'
  mode '0500'
  sensitive true
  variables(
    cmkserver: 'localhost',
    apitoken: lazy { `cat /opt/omd/sites/cmk/var/check_mk/web/automation/automation.secret`.chomp },
    sitename: node['cmk']['site_name']
  )
  # notifies :run, 'execute[run_activate-checkmks]', :immediately
end

execute 'run_activate-checkmks' do
  command '/tmp/activate-checkmks.py'
  ignore_failure true
  action :nothing
end

ruby_block 'Results' do
  only_if { ::File.exist?('/opt/omd/sites/cmk/var/check_mk/web/automation/automation.secret') }
  block do
    print "\n"
    File.open('/opt/omd/sites/cmk/var/check_mk/web/automation/automation.secret').each do |line|
      print line
    end
  end
end
