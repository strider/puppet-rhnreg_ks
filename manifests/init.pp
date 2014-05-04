class rhnreg_ks {
  rhn_register { 'title':
  ensure         => 'present',
  activationkeys => 'activationkey',
  username       => 'username',
  password       => 'password',
  profile_name   => 'profilename',
  server_url     => 'serverurl/XMLRPC',
  #force         => true,
  }
}

