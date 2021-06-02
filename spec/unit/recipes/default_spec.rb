# Cookbook:: checkmk
# Spec:: default
#
# Copyright:: 2019, Ed Overton, Apache 2.0

require 'spec_helper'

describe 'checkmk::agent-cmk' do
  context 'When all attributes are default, on CentOS 8' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'centos', '8'

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
