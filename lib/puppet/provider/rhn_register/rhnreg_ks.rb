Puppet::Type.type(:rhn_register).provide(:rhnreg_ks) do
  @doc = <<-EOS
    This provider registers a machine with RHN or a Satellite Server.
    If a machine is already registered it does nothing unless the force
    parameter is set to true.
  EOS

  confine :osfamily => :redhat

  commands :rhnreg_ks     => "rhnreg_ks"
  commands :unregister    => "/usr/local/bin/unregister"
  commands :checksat      => "/usr/local/bin/checksat"

  def build_parameters
    params = []

    if @resource[:username].nil? and @resource[:activationkeys].nil?
        self.fail("Either an activation key or username/password is required to register")
    end

    params << "--profilename" << @resource[:profile_name] if ! @resource[:profile_name].nil?
    params << "--username" << @resource[:username] if ! @resource[:username].nil?
    params << "--password" << @resource[:password] if ! @resource[:password].nil?
    params << "--nohardware" if ! @resource[:hardware]
    params << "--nopackages" if ! @resource[:packages]
    params << "--novirtinfo" if ! @resource[:virtinfo]
    params << "--norhnsd" if ! @resource[:rhnsd]
    params << "--activationkey" <<  @resource[:activationkeys] if ! @resource[:activationkeys].nil?
    params << "--proxy" <<  @resource[:proxy] if ! @resource[:proxy].nil?
    params << "--proxyUser" << @resource[:proxy_user] if ! @resource[:proxy_user].nil?
    params << "--proxyPassword" << @resource[:proxy_password] if ! @resource[:proxy_password].nil?
    params << "--sslCACert" <<  @resource[:ssl_ca_cert] if ! @resource[:ssl_ca_cert].nil?
    params << "--serverUrl" << @resource[:server_url] if ! @resource[:server_url].nil?
    params << "--force" if @resource[:force]

    params.each do |pm|
      Puppet.debug("#{pm}")
    end

    return params
  end

  def register
    cmd = build_parameters
    rhnreg_ks(*cmd)
  end
  
  def checkserver
    Puppet.debug("Checking if the server is in #{@resource[:server_url]}")
    checksat @resource[:name], @resource[:username], @resource[:password], @resource[:server_url]
  end

  def create
    register
  end

  def destroy
    Puppet.debug("This server will be locally and remotely unregistered")
    begin
      unregister @resource[:name], @resource[:username], @resource[:password], @resource[:server_url]
    rescue Exception => e
      self.fail("The server #{@resource[:server_url]} could not be contacted")
    end
    FileUtils.rm_f("/etc/sysconfig/rhn/systemid")
  end

  def exists?
    Puppet.debug("Verifying if the server is already registered")
      if File.exists?("/etc/sysconfig/rhn/systemid") && File.open("/etc/sysconfig/rhn/systemid").grep(/#{@resource[:name]}/).any? 
       begin
         checkserver
       rescue Exception => e
        Puppet.debug("Failed to get servername from #{@resource[:server_url]}")
        if @resource[:force] == true
         destroy
         register
        else
         destroy
         register
        end
       end
        return true
      else
        destroy
        return false
      end
    end

  end
