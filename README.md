# PUPPET-RHNREG_KS

This module provides Custom Puppet Provider to handle Red Hat Network
Registering. It works with `RHN` or a `Red Hat Network Satellite` Server.

## License

## Requirements
* puppet-boolean [on GitHub](https://github.com/adrienthebo/puppet-boolean)

## Authors
* Gaël Chamoulaud (gchamoul at redhat dot com)

## Type and Provider

The module adds the following new types:

* `rhn_register` for managing Red Hat Network Registering

### Parameters

- **activationkeys**: The activation key to use when registering the system (cannot be used with username and password)
- **ensure**: Valid values are `present`, `absent`. Default value is `present`.
- **force**: Should the registration be forced. Use this option with caution, setting it true will cause the rhnreg_ks command to be run every time runs. Default value `false`.
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

### Example

<pre>
rhn_register { 'server.example.com':
  ensure         => present,
  activationkeys => '1-rhel-x86_64-6.3',
  force          => true,
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
