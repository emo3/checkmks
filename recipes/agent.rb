#
# Cookbook:: checkmk
# Recipe:: default
#
# Copyright:: 2019, Ed Overton, Apache 2.0
epel_local_repo 'check_mk-agent'
package 'xinetd'

package 'check-mk-agent' do
  source 'http://10.1.1.101/sandbox/check_mk/agents/check-mk-agent-1.5.0p21-1.noarch.rpm'
  action :install
end

ruby_block 'insert_line' do
  block do
    file = Chef::Util::FileEdit.new("/etc/hosts.allow")
    file.insert_line_if_no_match("/#{node['cmk']['server_ip']}/", "check_mk_agent : #{node['cmk']['server_ip']}")
    file.write_file
  end
end

template '/etc/xinetd.d/check-mk-agent' do
  source 'check-mk-agent'
  variables(
    ip_mk_server: node['cmk']['server_ip']
  )
  mode 0644
  action :create
end
