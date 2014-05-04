# PUPPET-RHNREG_KS

This module provides a custom puppet provider to handle RHN, SATELLITE 
and SPACEWALK server registering/un-registering.

## License

Read Licence file for more information.

## Requirements
* puppet-boolean [on GitHub](https://github.com/adrienthebo/puppet-boolean)

## Authors
* Gaël Chamoulaud (gchamoul at redhat dot com)

## Contributors 
* Thomas Foster (Thomas dot Foster eighty at gmail dot com)

## Type and Provider

The module adds the following new types:

* `rhn_register` for managing Red Hat Network Registering

### Parameters

- **activationkeys**: The activation key to use when registering the system
- **ensure**: Valid values are `present`, `absent`. Default value is `present`.
- **force**: Should the registration be forced. Use this option with caution, setting it true will cause the rhnreg_ks command to be run every time runs. Default value `false`.
- **hardware**: Whether or not the hardware information should be probed. Default value is `true`.
- **packages**: Whether or not packages information should be probed. Default value is `true`.
- **password**: The password to use when registering the system (required)
- **profile_name**: The name the system should use in RHN or Satellite(if not set defaults to `hostname`)
- **proxy**: If needed, specify the HTTP Proxy
- **proxy_password**: Specify a password to use with an authenticated http proxy
- **proxy_user**: Specify a username to use with an authenticated http proxy
- **rhnsd**: Whether or not rhnsd should be started after registering. Default value is `true`.
- **server_url**: Specify a url to use as a server (required)
- **ssl_ca_cert**: Specify a file to use as the ssl CA cert
- **username**: The username to use when registering the system (required)
- **virtinfo**: Whether or not virtualiztion information should be uploaded. Default value is `true`.

### Example

Registering Clients to RHN Server with activation keys:

<pre>
rhn_register { 'server.example.com':
  activationkeys => '888888888eeeeeee888888eeeeee8888',
  ensure         => 'present',
  username       => 'myusername',
  password       => 'mypassword',
  server_url     => 'https://xmlrpc.rhn.redhat.com/XMLRPC',
  ssl_ca_cert    => '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT',
}
</pre>

Un-register Clients RHN Server with activation keys:

<pre>
rhn_register { 'server.example.com':
  activationkeys => '888888888eeeeeee888888eeeeee8888',
  ensure         => 'absent',
  username       => 'myusername',
  password       => 'mypassword',
  server_url     => 'https://xmlrpc.rhn.redhat.com/XMLRPC',
  ssl_ca_cert    => '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT',
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

### Notes
`username` and `password` are required to connect to the RHN, SATELLITE, SPACEWALK server to check if server previously exists.

In a normal configuration username/password and activationkeys could not be used together, but since this module will support
RHN, SATELLITE, SPACEWALK register and un-register by being able to log into the system using the api it needs username/password.

To see the output of what the module is doing, run with the --debug option.

## Issues

Please file any issues or suggestions on [on GitHub](https://github.com/strider/puppet-rhnreg_ks/issues)
