#
# Cookbook:: checkmk
# Recipe:: default
#
# Copyright:: 2019, Ed Overton, Apache 2.0
package %w(xinetd openssl python epel-release)

execute 'get checkmk' do
  command 'wget https://checkmk.com/support/1.5.0p21/check-mk-raw-1.5.0p21-el7-38.x86_64.rpm'
  not_if { File.exist?('/check-mk-raw-1.5.0p21-el7-38.x86_64.rpm') }
end

execute 'install checkmk' do
  command 'yum -y install check-mk-raw-1.5.0p21-el7-38.x86_64.rpm'
  not_if { File.exist?('/opt/omd/sites') }
end

execute 'create_sandbox' do
  command 'omd create sandbox'
  not_if { File.exist?('/opt/omd/sites/sandbox') }
end

execute 'start sandbox' do
  command 'omd start sandbox'
  not_if ('ps -eaf | grep -v grep | grep sandbox')
  returns [0, 1, 2]
end

execute 'change passwd' do
  command "su - sandbox -c 'htpasswd -b -m ~/etc/htpasswd cmkadmin cmkadmin'"
  # returns [0, 1, 2]
end

execute 'fix for selinux' do
  command '/usr/sbin/setsebool -P httpd_can_network_connect=1'
  # returns [0, 1, 2]
end
