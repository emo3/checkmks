name             'checkmk'
maintainer       'Ed Overton'
maintainer_email 'bademail@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures checkmk'
version          '1.3.0'
chef_version     '>= 14.0' if respond_to?(:chef_version)

supports 'redhat'
supports 'centos'

depends 'server_utils'
