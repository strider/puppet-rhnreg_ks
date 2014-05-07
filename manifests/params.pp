class rhnreg_ks::params {
  case $::operatingsystemmajrelease {
    5: {
      $activationkeys = '2-rhel5-key'
    }
    6: {
      $activationkeys = '2-rhel6-key'
    }
    default: {
      $activationkeys = undef
    }
  }
}
