#
# Cookbook:: checkmk
# Recipe:: agent
#
# Copyright:: 2019, Ed Overton, Apache 2.0
epel_local_repo 'check_mk-agent'
package %w(xinetd check-mk-agent)

ruby_block 'insert_line' do
  block do
    file = Chef::Util::FileEdit.new('/etc/hosts.allow')
    file.insert_line_if_no_match("/#{node['cmk']['server_ip']}/", "check_mk_agent : #{node['cmk']['server_ip']}")
    file.write_file
  end
end

template '/etc/xinetd.d/check-mk-agent' do
  source 'check-mk-agent'
  variables(
    ip_mk_server: node['cmk']['server_ip']
  )
  mode '0644'
  action :create
end
