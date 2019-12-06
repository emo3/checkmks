default['cmk'].tap do |cmk|
  cmk['media_url'] = 'http://websrv/media'
  cmk['cmk_release'] = '1.6.0'
  cmk['cmk_version'] = 'p6'
  cmk['server_rpm'] = "check-mk-raw-#{cmk['cmk_release']}#{cmk['cmk_version']}-el7-38.x86_64.rpm"
  cmk['agent_rpm'] = "check-mk-agent-#{cmk['cmk_release']}#{cmk['cmk_version']}-1.noarch.rpm"
  cmk['instance_name'] = 'cmk'
  cmk['server_name'] = 'checkmks'
  cmk['admin_passwd'] = 'cmkadmin'
  cmk['server_ip'] = node['server_ip']
  cmk['api_url'] = "http://#{cmk['server_name']}/#{cmk['instance_name']}/check_mk/webapi.py"
  cmk['api_key'] = '4704e9fb-4eb5-4616-94ac-546e5d4a4668'
  cmk['api_user'] = 'automation'
  cmk['api_login'] = "_username=#{cmk['api_user']}&_secret=#{cmk['api_key']}"
  cmk['code'] = '0'
end
