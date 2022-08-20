default['cmk'].tap do |cmk|
  cmk['cmk_release'] = '2.1.0p9'
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
  cmk['api_url'] = "http://#{cmk['server_name']}/#{cmk['site_name']}/check_mk/webapi.py"
  cmk['api_token'] = node['CMK_TOKEN'] || '2a6c4125-af68-48f4-b139-4a06e800a4d4'
  cmk['api_user'] = 'automation'
  cmk['api_login'] = "_username=#{cmk['api_user']}&_secret=#{cmk['api_token']}"
end
