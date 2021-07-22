#
# Cookbook:: checkmk
# Recipe:: agent-cmk
#
# Copyright:: 2019, Ed Overton, Apache 2.0
node.default['cmk']['api_token'] = node['cmk_token']

package 'xinetd'

service 'xinetd' do
  supports status: true, restart: true, reload: true
  action [ :enable, :start ]
end

append_if_no_line 'hosts_allow' do
  path '/etc/hosts.allow'
  line "check_mk_agent : #{node['server_ip']}"
  notifies :reload, 'service[xinetd]', :immediately
end

template '/etc/xinetd.d/check_mk' do
  source 'check-mk-agent'
  variables(
    ip_mk_server: node['server_ip']
  )
  mode '0644'
  action :create
  notifies :reload, 'service[xinetd]', :immediately
end

append_if_no_line node['cmk']['server_name'] do
  path '/etc/hosts'
  line "#{node['server_ip']} #{node['cmk']['server_name']}"
end

remote_file "#{Chef::Config[:file_cache_path]}/#{node['cmk']['agent_rpm']}" do
  source "http://#{node['cmk']['server_name']}/#{node['cmk']['site_name']}/check_mk/agents/#{node['cmk']['agent_rpm']}"
  action :create
end

package 'agent-rpm' do
  source "#{Chef::Config[:file_cache_path]}/#{node['cmk']['agent_rpm']}"
  action :install
end

# Create file from template
template '/tmp/add-checkmks.sh' do
  source 'add-checkmks.sh.erb'
  mode '0500'
  sensitive true
  variables(
    cmkserver: node['cmk']['server_name'],
    apitoken: node['cmk']['api_token'],
    agenthostname: node['hostname'],
    agentip: node['ipaddress']
  )
  notifies :run, 'execute[run_add-checkmks]', :immediately
end

execute 'run_add-checkmks' do
  command '/tmp/add-checkmks.sh'
  action :nothing
end

# Create file from template
template '/tmp/discover-checkmks.sh' do
  source 'discover-checkmks.sh.erb'
  mode '0500'
  sensitive true
  variables(
    cmkserver: node['cmk']['server_name'],
    apitoken: node['cmk']['api_token'],
    agenthostname: node['hostname']
  )
  notifies :run, 'execute[run_discover-checkmks]', :immediately
end

execute 'run_discover-checkmks' do
  command '/tmp/discover-checkmks.sh'
  action :nothing
end

# Create file from template
template '/tmp/activate-checkmks.sh' do
  source 'activate-checkmks.sh.erb'
  mode '0500'
  sensitive true
  variables(
    cmkserver: node['cmk']['server_name'],
    apitoken: node['cmk']['api_token'],
    sitename: node['cmk']['site_name']
  )
  notifies :run, 'execute[run_activate-checkmks]', :immediately
end

execute 'run_activate-checkmks' do
  command '/tmp/activate-checkmks.sh'
  action :nothing
end
