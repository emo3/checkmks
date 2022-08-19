#
# Cookbook:: checkmks
# Recipe:: add_host1
#
# Copyright:: 2019, Ed Overton, Apache 2.0
require 'net/http'
require 'uri'

cmd = "#{node['cmk']['api_url']}?action=add_host&#{node['cmk']['api_login']}"
puts "cmd2=[#{cmd}]"
uri = URI.parse(cmd)
# uri = URI.parse("#{node['cmk']['api_url']}?action=get_all_hosts&#{node['cmk']['api_login']}")
request = Net::HTTP::Post.new(uri)
# form_data = URI.x-www-form-urlencoded({
# aform = {
#   'hostname' => 'checkmks',
#   'folder' => '',
#   'attributes' => {
#     'ipaddress' => ahost_ip,
#     'site' => 'cmk',
#     'tag_agent' => 'cmk-agent'
#   }
# }
aform = { 'hostname': 'checkmks',
  'folder': '',
  'attributes': {
    'ipaddress': node['cmk']['server_ip'],
    'site': 'cmk',
    'tag_agent': 'cmk-agent',
  },
}
puts "aform=#{aform.to_s}"
form_data = URI.encode_www_form(aform)
request.body = form_data
puts request.body
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
    puts 'NOT FOUND '
  else
    puts 'FOUND'
  end
else
  puts "BAD=#{response.code}!"
end
