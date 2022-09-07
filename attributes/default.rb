default['cmk']['cmk_release'] = '2.0.0p27'
default['cmk']['media_url'] = "https://download.checkmk.com/checkmk/#{node['cmk']['cmk_release']}"
default['cmk']['el_version'] =
  if node['platform_version'] < '8'
    '7'
  else
    '8'
  end
default['cmk']['server_rpm'] = "check-mk-free-#{node['cmk']['cmk_release']}-el#{node['cmk']['el_version']}-38.x86_64.rpm"
default['cmk']['site_name'] = 'cmk'
default['cmk']['server_name'] = 'checkmks'
default['cmk']['admin_passwd'] = 'cmkadmin'
