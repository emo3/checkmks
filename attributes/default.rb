default['cmk'].tap do |cmk|
  cmk['media_url'] = 'http://websrv/media'
  cmk['cmk_release'] = '2.0.0'
  cmk['cmk_version'] = 'p5'
  cmk['el_version'] = if node['platform_version'] < '8'
                        '7'
                      else
                        '8'
                      end
  cmk['server_rpm'] = "check-mk-raw-#{cmk['cmk_release']}#{cmk['cmk_version']}-el#{cmk['el_version']}-38.x86_64.rpm"
  cmk['agent_rpm'] = "check-mk-agent-#{cmk['cmk_release']}#{cmk['cmk_version']}-1.noarch.rpm"
  cmk['instance_name'] = 'cmk'
  cmk['server_name'] = 'checkmks'
  cmk['server_ip'] = '10.1.1.20'
  cmk['admin_passwd'] = 'cmkadmin'
  cmk['server_ip'] = node['server_ip']
  cmk['api_url'] = "http://#{cmk['server_name']}/#{cmk['instance_name']}/check_mk/webapi.py"
  cmk['api_key'] = '9f7fe01a-0c3e-430e-9e2b-1d4500a2ead8'
  cmk['api_user'] = 'automation'
  cmk['api_login'] = "_username=#{cmk['api_user']}&_secret=#{cmk['api_key']}"
  cmk['code'] = '0'
end
