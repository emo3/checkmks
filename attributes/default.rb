default['cmk'].tap do |cmk|
  cmk['media_url'] = 'http://websrv/media'
  cmk['cmk_release'] = '1.6.0'
  cmk['cmk_version'] = 'p6'
  cmk['server_rpm'] = "check-mk-raw-#{cmk['cmk_release']}#{cmk['cmk_version']}-el7-38.x86_64.rpm"
  cmk['agent_rpm'] = "check-mk-agent-#{cmk['cmk_release']}#{cmk['cmk_version']}-1.noarch.rpm"
  cmk['instance_name'] = 'cmk'
  cmk['admin_passwd'] = 'cmkadmin'
  cmk['server_ip'] = node['server_ip']
end
