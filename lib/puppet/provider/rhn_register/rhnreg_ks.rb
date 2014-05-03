require 'xmlrpc/client'
require 'net/https'
require 'openssl'


Puppet::Type.type(:rhn_register).provide(:rhnreg_ks) do
  @doc = <<-EOS
    This provider registers a machine with RHN or a Satellite Server.
    If a machine is already registered it does nothing unless the force
    parameter is set to true.
  EOS

  confine :osfamily => :redhat

  commands :rhnreg_ks     => "rhnreg_ks"

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

  def create
    register
  end

  def checkserver(mysystem, mylogin, mypassword, myurl)

    Puppet.debug("I am checking the server for #{mysystem}")

    @MYSYSTEM = mysystem.to_s
    @SATELLITE_LOGIN = mylogin.to_s
    @SATELLITE_PASSWORD = mypassword.to_s
    @SATELLITE_URL = URI(myurl.to_s)
    @SATELLITE_URL.path = '/rpc/api'
    @use_ssl = true
    @mytimeout = 30

    @client = XMLRPC::Client.new2("#{@SATELLITE_URL}") 

    #disable check of ssl cert
    @client.instance_variable_get(:@http).verify_mode = OpenSSL::SSL::VERIFY_NONE

    @key = @client.call('auth.login', @SATELLITE_LOGIN, @SATELLITE_PASSWORD)
    serverList = @client.call('system.listSystems', @key)
        serverList.each do |x|
          if x['name'] == "#{@MYSYSTEM}"
	        return true
          else
                next
          end
        end
    raise Exception, "Server #{@MYSYSTEM} not found"
    

  end

  def destroy_server_name(mysystem, mylogin, mypassword, myurl)

      Puppet.debug("Destroying server #{mysystem} from #{myurl}")

      @MYSYSTEM = mysystem.to_s
      @SATELLITE_LOGIN = mylogin.to_s
      @SATELLITE_PASSWORD = mypassword.to_s
      @SATELLITE_URL = URI(myurl.to_s)
      @SATELLITE_URL.path = '/rpc/api'
      @use_ssl = true
      @mytimeout = 30
      
        def delete_server(myserver, myserverid)

                puts "This script has deleted server #{myserver} with id: #{myserverid} from #{@SATELLITE_URL.host}"
                return_code = @client.call('system.deleteSystems', @key, myserverid)
        end

       @client = XMLRPC::Client.new2("#{@SATELLITE_URL}")

       #disable check of ssl cert
       @client.instance_variable_get(:@http).verify_mode = OpenSSL::SSL::VERIFY_NONE

       @key = @client.call('auth.login', @SATELLITE_LOGIN, @SATELLITE_PASSWORD)
         serverList = @client.call('system.listSystems', @key)
           serverList.each do |x|
             if x['name'] == "#{@MYSYSTEM}"
               delete_server(x['name'], x['id'])
             else
               next
             end
           end
       FileUtils.rm_f("#{@SFILE}")
  end


  def destroy
      Puppet.debug("This server will be locally and remotely unregistered")

      if ! @resource[:profile_name].nil?
             destroy_server_name(@resource[:profile_name], @resource[:username], @resource[:password], @resource[:server_url])
      else
             destroy_server_name(@resource[:name], @resource[:username], @resource[:password], @resource[:server_url])
      end
  end

  def exists?
    @SFILE = '/etc/sysconfig/rhn/systemid'

    Puppet.debug("Verifying if the server is already registered")
      if File.exists?("#{@SFILE}") and File.open("#{@SFILE}").grep(/#{@resource[:name]}/).any? and File.open("#{@SFILE}").grep(/#{@resource[:profile_name]}/).any?
       #begin
           if ! @resource[:profile_name].nil?
              checkserver(@resource[:profile_name], @resource[:username], @resource[:password], @resource[:server_url])
               if @resource[:force] == true
                   destroy
                   return false
               end
               return true
           else
             checkserver(@resource[:name], @resource[:username], @resource[:password], @resource[:server_url])
               if @resource[:force] == true
                   destroy
                   return false
               end
               return true
            end
        #end
      else
          destroy
          return false
      end
  end
end

