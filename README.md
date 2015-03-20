# PUPPET-RHNREG_KS

This module provides Custom Puppet Providers to handle Red Hat Network
Registering and subscribing to additional channels.
It works with `RHN` or a `Red Hat Network Satellite` Server.

## License

Read Licence file for more information.

## Requirements
* puppet-boolean [on GitHub](https://github.com/adrienthebo/puppet-boolean)

## Authors
* Gaël Chamoulaud (gchamoul at redhat dot com)

## Types and Providers

The module adds the following new types:

* `rhn_register` for managing Red Hat Network Registering
* `rhn_channel` for adding/removing channels

### Parameters

#### rhn_register

- **activationkeys**: The activation key to use when registering the system (cannot be used with username and password)
- **ensure**: Valid values are `present`, `absent`. Default value is `present`.
- **force**: Should the registration be forced. Use this option with caution, setting it true will cause the rhnreg_ks command to be run every time runs. Default value `false`.
- **force_check**: Should the registration be forced if the server_url on the current system has a mismatch with the one defined during the puppet run. Default value `false`.
- **hardware**: Whether or not the hardware information should be probed. Default value is `true`.
- **packages**: Whether or not packages information should be probed. Default value is `true`.
- **password**: The password to use when registering the system
- **profile_name**: The name the system should use in RHN or Satellite
- **proxy**: If needed, specify the HTTP Proxy
- **proxy_password**: Specify a password to use with an authenticated http proxy
- **proxy_user**: Specify a username to use with an authenticated http proxy
- **rhnsd**: Whether or not rhnsd should be started after registering. Default value is `true`.
- **server_url**: Specify a url to use as a server
- **ssl_ca_cert**: Specify a file to use as the ssl CA cert
- **username**: The username to use when registering the system
- **virtinfo**: Whether or not virtualiztion information should be uploaded. Default value is `true`.

#### rhn_channel

- **channel** The channel to manage. (This is the namevar).
- **ensure** Valid values are `present`, `absent`.
- **username** The username to use when adding/removing a channel.
- **password** The password to use when adding/removing a channel.

### Example

Registering Clients to Red Hat Network RHN Satellite Server:

<pre>
rhn_register { 'server.example.com':
  activationkeys => '1-myactivationkey',
  server_url     => 'https://satellite.example.com/XMLRPC',
  ssl_ca_cert    => '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT',
}
</pre>

Registering Clients to RHN Server:

<pre>
rhn_register { 'server.example.com':
  activationkeys => '888888888eeeeeee888888eeeeee8888',
  username       => 'myusername',
  password       => 'mypassword',
  server_url     => 'https://xmlrpc.rhn.redhat.com/XMLRPC',
  ssl_ca_cert    => '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT',
  force          => true,
}
</pre>

Adding a Channel:

<pre>
rhn_channel { 'centos6-scl-x86_64':
  ensure   => present,
  username => 'myusername',
  password => 'mypassword',
}
</pre>


## Installing

In your puppet modules directory:

    git clone https://github.com/strider/puppet-rhnreg_ks.git

Ensure the module is present in your puppetmaster's own environment (it doesn't
have to use it) and that the master has pluginsync enabled.  Run the agent on
the puppetmaster to cause the custom types to be synced to its local libdir
(`puppet master --configprint libdir`) and then restart the puppetmaster so it
loads them.

## Issues

Please file any issues or suggestions on [on GitHub](https://github.com/strider/puppet-rhnreg_ks/issues)
