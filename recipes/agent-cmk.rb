#
# Cookbook:: checkmk
# Recipe:: agent-cmk
#
# Copyright:: 2019, Ed Overton, Apache 2.0
epel_local_repo 'agent-cmk'

remote_file "#{Chef::Config[:file_cache_path]}/#{node['cmk']['agent_rpm']}" do
    source "http://checkmks/cmk/check_mk/agents/#{node['cmk']['agent_rpm']}"
    action :create
end

package 'agent-rpm' do
    source "#{Chef::Config[:file_cache_path]}/#{node['cmk']['agent_rpm']}"
    action :install
end
