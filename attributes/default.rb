default['cmk'].tap do |cmk|
  cmk['cmk_release'] = '2.0.0p27'
  cmk['media_url'] = "https://download.checkmk.com/checkmk/#{node['cmk']['cmk_release']}"
  cmk['el_version'] = if node['platform_version'] < '8'
                        '7'
                      else
                        '8'
                      end
  cmk['server_rpm'] = "check-mk-free-#{cmk['cmk_release']}-el#{cmk['el_version']}-38.x86_64.rpm"
  cmk['site_name'] = 'cmk'
  cmk['server_name'] = 'checkmks'
  cmk['admin_passwd'] = 'cmkadmin'
end
