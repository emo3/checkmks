#
# Cookbook:: checkmk
# Recipe:: add_host
#
# Copyright:: 2019, Ed Overton, Apache 2.0

execute 'get_all_hosts' do
  command "curl \"#{node['cmk']['api_url']}?action=get_all_hosts&#{node['cmk']['api_login']}\""
  sensitive true
  live_stream true
  action :run
end

# Creating a host:<br>
# curl "http://checkmks/cmk/check_mk/webapi.py?action=add_host&_username=automation&_secret=$akey" -d 'request={"hostname":"checkmks","folder":"","attributes":{"ipaddress":"10.1.1.20","site":"cmk","tag_agent":"cmk-agent"}}'
# Executing a Service Discovery<br>
# curl "http://checkmks/cmk/check_mk/webapi.py?action=discover_services&_username=automation&_secret=$akey" -d 'request={"hostname":"checkmks"}'
# Activating changes
# curl "http://checkmks/cmk/check_mk/webapi.py?_secret=$akey&_username=automation&action=activate_changes" -d 'request={"sites":["cmk"]}'
