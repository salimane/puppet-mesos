require 'spec_helper'

describe 'mesos', :type => :class do

  context 'with ensure' do
    let(:version) { '0.14' }
    let(:params) {{
      :ensure => version
    }}

    it { should contain_package('mesos').with({
      'ensure' => version
    }) }

    it { should_not contain_package('python').with({
      'ensure' => 'present'
    }) }
  end

  context 'with given version' do
    let(:version) { '0.20' }
    let(:params) {{
      :version => version
    }}

    it { should contain_package('mesos').with({
      'ensure' => version
    }) }
  end

  context 'remove mesos' do
    let(:version) { 'absent' }
    let(:params) {{
      :ensure => version
    }}

    it { should contain_package('mesos').with({
      'ensure' => version
    }) }
  end

  context 'specify ulimit' do
    let(:ulimit) { 16384 }
    let(:file) { '/etc/default/mesos' }
    let(:params) {{
      :ulimit => ulimit
    }}

    it { should contain_file(file).with_content(/ULIMIT="-n #{ulimit}"/) }
  end

  it { should contain_class('mesos') }
  it { should contain_class('mesos::repo') }
  it { should contain_class('mesos::install') }
  it { should contain_class('mesos::config') }
  it { should contain_class('mesos::config').that_requires('Class[mesos::install]') }

  it { should compile.with_all_deps }

  context 'change pyton packge name' do
    let(:python) { 'python3' }
    let(:params) {{
      :manage_python => true,
      :python_package => python
    }}

    it { should contain_package(python).with({
      'ensure' => 'present'
    }) }
  end

  context 'set LOGS variable' do
    let(:file) { '/etc/default/mesos' }
    let(:params) {{
      :log_dir => '/var/log/mesos'
    }}

    it { should contain_file(file).with_content(/LOGS="\/var\/log\/mesos"/) }
  end

  context 'remove packaged services' do
    context 'keeps everything' do
      it { should contain_class('mesos::install').with('remove_package_services' => false) }
    end

    context 'remvoes packaged upstart config' do
      let(:params) {{
          :force_provider => 'none'
      }}

      it { should contain_class('mesos::install').with('remove_package_services' => true) }
    end
  end
end
