Puppet::Type.type(:rhn_channel).provide(:rhn_channel) do
  confine :osfamily => :redhat

  commands :rhn_channel => 'rhn-channel'

  def self.instances
    begin
      channels = rhn_channel('--list')
    rescue Puppet::ExecutionFailure => e
      Puppet.debug "#rhn_channel --list had an error -> #{e.inspect}"
      return {}
    end
    channels.split("\n").collect do |line|
      new(:name   => line,
          :ensure => :present
         )
    end
  end

  def self.prefetch(resources)
    instances.each do |prov|
      if resource = resources[prov.name]
        resource.provider = prov
      end
    end
  end

  def build_parameters
    if @resource[:username].nil? or @resource[:password].nil?
      self.fail("username and password are required to add/remove channels")
    end
    params = []
    params << "--channel=#{@resource[:name]}"
    params << "--user=#{@resource[:username]}"
    params << "--password=#{@resource[:password]}"
    return params
  end

  def create
    cmd = build_parameters
    cmd << "--add"

    rhn_channel(*cmd)
  end

  def destroy
    cmd = build_parameters
    cmd << "--remove"

    rhn_channel(*cmd)
  end

  def exists?
    @property_hash[:ensure] == :present
  end

end
