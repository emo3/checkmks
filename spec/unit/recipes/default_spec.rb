# Cookbook:: checkmk
# Spec:: default
#
# Copyright:: 2019, Ed Overton, Apache 2.0

require 'spec_helper'

describe 'checkmks::server' do
  context 'When all attributes are default, on CentOS 8' do
    # for a complete list of available platforms and versions see:
    # https://github.com/chefspec/fauxhai/blob/master/PLATFORMS.md
    platform 'centos', '8'

    before do
      stub_command('ps -eaf | grep -v grep | grep cmk').and_return(true)
    end

    it 'converges successfully' do
      expect { chef_run }.to_not raise_error
    end
  end
end
