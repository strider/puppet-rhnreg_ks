class rhnreg_ks (
  $serverurl,
  $username,
  $password,
  $server = $::hostname,
  $profilename = $::fqdn,
  $presentorabsent = 'present',
  $cacert = '/usr/share/rhn/RHN-ORG-TRUSTED-SSL-CERT',
  $useforce = false,
  $activationkeys = $rhnreg_ks::params::activationkeys
) inherits rhnreg_ks::params {
  if $activationkeys == 'undef' {
    fail('No Activation key specified')
  }

  rhn_register { $server:
  ensure         => $presentorabsent,
  activationkeys => $activationkeys,
  username       => $username,
  password       => $password,
  profile_name   => $profilename,
  server_url     => $serverurl,
  ssl_ca_cert    => $cacert,
  force          => $useforce,
  }
}
