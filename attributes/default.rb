default['cmk'].tap do |cmk|
  cmk['media_url'] = 'http://websrv/media'
  cmk['cmk_release'] = '2.0.0'
  cmk['cmk_version'] = 'p5'
  # cmk['cmk_release'] = '1.6.0'
  # cmk['cmk_version'] = 'p24'
  cmk['el_version'] = if node['platform_version'] < '8'
                        '7'
                      else
                        '8'
                      end
  cmk['server_rpm'] = "check-mk-raw-#{cmk['cmk_release']}#{cmk['cmk_version']}-el#{cmk['el_version']}-38.x86_64.rpm"
  cmk['instance_name'] = 'cmk'
  cmk['server_name'] = 'checkmks'
  cmk['server_ip'] = node['server_ip']
  cmk['admin_passwd'] = 'cmkadmin'
  cmk['local_url'] = 'n'
end
