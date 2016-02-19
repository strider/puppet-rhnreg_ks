require 'puppet'
require 'puppet/type/rhn_channel'

describe Puppet::Type.type(:rhn_channel) do

  before :each do
    @channel = Puppet::Type.type(:rhn_channel).new({:channel => 'foo', :username => 'user', :password => 'pass'})
  end

  it 'should accept a channel name' do
    expect(@channel[:channel]).to eq('foo')
  end

  it 'should require a username when adding channel' do
    expect {
      Puppet::Type.type(:rhn_channel).new({:channel => 'foo', :ensure => 'present', :password => 'pass'})
    }.to raise_error(/username and password are required when adding or removing channels/)
  end

  it 'should require a username when removing channel' do
    expect {
      Puppet::Type.type(:rhn_channel).new({:channel => 'foo', :ensure => 'absent', :password => 'pass'})
    }.to raise_error(/username and password are required when adding or removing channels/)
  end

  it 'should fail with a username containing spaces' do
    expect {
      Puppet::Type.type(:rhn_channel).new({:channel => 'foo', :username => 'us er', :password => 'pass'})
    }.to raise_error(/Invalid username us er. Whitespace not permitted/)
  end

  it 'should fail with a username containing a &' do
    expect {
      Puppet::Type.type(:rhn_channel).new({:channel => 'foo', :username => 'us&er', :password => 'pass'})
    }.to raise_error(/Invalid username us&er. '&' character not permitted/)
  end

  it 'should require a password when adding channel' do
    expect {
      Puppet::Type.type(:rhn_channel).new({:channel => 'foo', :ensure => 'present', :username => 'user'})
    }.to raise_error(/username and password are required when adding or removing channels/)
  end

  it 'should require a password when removing channel' do
    expect {
      Puppet::Type.type(:rhn_channel).new({:channel => 'foo', :ensure => 'absent', :username => 'user'})
    }.to raise_error(/username and password are required when adding or removing channels/)
  end

end
