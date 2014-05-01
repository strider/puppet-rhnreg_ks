require 'xmlrpc/client'
require 'net/https'
require 'openssl'


Puppet::Type.type(:rhn_register).provide(:rhnreg_ks) do
  @doc = <<-EOS
    This provider registers a machine with an RHN, Satellite or Spacewalk
    Server. If a machine is already registered it does nothing unless the
    force parameter is set to true or the systemid file is different from
    hostname or profilename (Supports VMware cloning servers).
  EOS

  confine :osfamily => :redhat

  commands :rhnreg_ks     => "rhnreg_ks"

  def build_parameters
    params = []

    if @resource[:username].nil? and @resource[:activationkeys].nil? and @resource[:password].nil? and @resource[:server_url].nil?
        self.fail("Username/Password or Activationkey and ServerURL are required")
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

  def create
    Puppet.debug("Server is not registered, Registering server now.")
    register
  end
  
  def check_server(mysystem, mylogin, mypassword, myurl)

    @MYSYSTEM = mysystem.to_s
    @SATELLITE_LOGIN = mylogin.to_s
    @SATELLITE_PASSWORD = mypassword.to_s
    @SATELLITE_URL = URI(myurl.to_s)
    @SATELLITE_URL.path = '/rpc/api'

    @client = XMLRPC::Client.new2("#{@SATELLITE_URL}") 

    #disable check of ssl cert
    @client.instance_variable_get(:@http).verify_mode = OpenSSL::SSL::VERIFY_NONE
     begin
      @key = @client.call('auth.login', @SATELLITE_LOGIN, @SATELLITE_PASSWORD)
      rescue Exception => e
       self.fail("Failed to contact the server #{@resource[:server_url]}")
     end
       serverList = @client.call('system.listSystems', @key)
       serverList.each do |x|
         if x['name'] == "#{@MYSYSTEM}"
           return true
         else
           next
         end
       end
      Puppet.debug("Server #{@MYSYSTEM} not found")
      return false
  end

  def destroy_server(mysystem, mylogin, mypassword, myurl)
    @MYSYSTEM = mysystem.to_s
    @SATELLITE_LOGIN = mylogin.to_s
    @SATELLITE_PASSWORD = mypassword.to_s
    @SATELLITE_URL = URI(myurl.to_s)
    @SATELLITE_URL.path = '/rpc/api'

      def delete_server(myserver, myserverid)
        Puppet.debug("This script has deleted server #{myserver} with id: #{myserverid} from #{@SATELLITE_URL.host}")
        return_code = @client.call('system.deleteSystems', @key, myserverid)
      end

    @client = XMLRPC::Client.new2("#{@SATELLITE_URL}")

    #disable check of ssl cert
    @client.instance_variable_get(:@http).verify_mode = OpenSSL::SSL::VERIFY_NONE

    begin
    @key = @client.call('auth.login', @SATELLITE_LOGIN, @SATELLITE_PASSWORD)
    rescue Exception => e
      self.fail("Failed to contact the server #{@resource[:server_url]}")
    end
      serverList = @client.call('system.listSystems', @key)
      serverList.each do |x|
        if x['name'] == "#{@MYSYSTEM}"
          Puppet.debug("Destroying server #{@MYSYSTEM} from #{@SATELLITE_URL}")
          delete_server(x['name'], x['id'])
        else
          next
        end
      end
    FileUtils.rm_f("#{@SFILE}")
  end


  def destroy
    if ! @resource[:profile_name].nil?
      destroy_server(@resource[:profile_name], @resource[:username], @resource[:password], @resource[:server_url])
    else
      destroy_server(@resource[:name], @resource[:username], @resource[:password], @resource[:server_url])
    end
  end

  def exists?
    @SFILE = '/etc/sysconfig/rhn/systemid'
      if File.exists?("#{@SFILE}") and File.open("#{@SFILE}").grep(/#{@resource[:name]}/).any? and File.open("#{@SFILE}").grep(/#{@resource[:profile_name]}/).any?
        if ! @resource[:profile_name].nil?
          Puppet.debug("Checking if the server #{@resource[:profile_name]} is already registered")
          value = check_server(@resource[:profile_name], @resource[:username], @resource[:password], @resource[:server_url])
            if "#{value}" == 'true'
              if @resource[:force] == true
                destroy
                return false
              end
                return true
            else
	      destroy
              return false
            end
        else
          Puppet.debug("Checking if the server #{@resource[:name]} is already registered")
          value = check_server(@resource[:name], @resource[:username], @resource[:password], @resource[:server_url])
            if "#{value}" == 'true'
              if @resource[:force] == true
                destroy
                return false
              end
                return true
            else
              destroy
              return false
            end
        end
      else
        destroy
        return false
      end
  end
end
