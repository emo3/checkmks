#
# Cookbook:: checkmk
# Recipe:: add_host
#
# Copyright:: 2019, Ed Overton, Apache 2.0
require 'net/http'
require 'uri'

ahost_name = 'checkmks'
# ahost_ip   = node['cmk']['server_ip']
cmd = "#{node['cmk']['api_url']}?action=get_host&#{node['cmk']['api_login']}"
puts "cmd=[#{cmd}]"
uri = URI.parse(cmd)
# uri = URI.parse("#{node['cmk']['api_url']}?action=get_all_hosts&#{node['cmk']['api_login']}")
request = Net::HTTP::Post.new(uri)
aform = { hostname => ahost_name }
form_data = URI.encode_www_form(aform)
request.body = form_data
req_options = {
  use_ssl: uri.scheme == 'https',
}
response = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
  http.request(request)
end
if response.is_a?(Net::HTTPSuccess)
  data = JSON.parse(response.body)
  puts data
  node.default['cmk']['code'] = data['result_code']
  if data['result_code'] == 1
    puts "NOT FOUND host[#{ahost_name}]"
  else
    puts 'FOUND'
  end
else
  puts "BAD=#{response.code}!"
end

# add the node, since it was not found
if node['cmk']['code'] == 1
  puts "adding host[#{ahost_name}]"
  include_recipe '::add_host1'
  # cmd = "curl \"#{node['cmk']['api_url']}?action=add_host&#{node['cmk']['api_login']}\" -d "
  # cmd = cmd + "'request={\"hostname\":\"#{ahost_name}\", \"folder\":\"\", \"attributes\":{\"ipaddress\":\"#{ahost_ip}\", \"site\":\"cmk\", \"tag_agent\":\"cmk-agent\"}}'"
  # puts cmd
  # execute 'add_host' do
  #   command cmd
  # end
end

# get all hosts
# curl "http://checkmks/cmk/check_mk/webapi.py?action=get_all_hosts&_username=automation&_secret=mysecret&request_format=python&output_format=python"
# get host
# curl "http://checkmks/cmk/check_mk/webapi.py?action=get_host&_username=automation&_secret=myautomationsecret&output_format=python&request_format=python" -d 'request={"hostname":"myserver123"}'
# Creating a host:<br>
# curl "http://checkmks/cmk/check_mk/webapi.py?action=add_host&_username=automation&_secret=$akey" -d 'request={"hostname":"checkmks","folder":"","attributes":{"ipaddress":"10.1.1.20","site":"cmk","tag_agent":"cmk-agent"}}'
# Executing a Service Discovery<br>
# curl "http://checkmks/cmk/check_mk/webapi.py?action=discover_services&_username=automation&_secret=$akey" -d 'request={"hostname":"checkmks"}'
# Activating changes
# curl "http://checkmks/cmk/check_mk/webapi.py?_secret=$akey&_username=automation&action=activate_changes" -d 'request={"sites":["cmk"]}'
