class rhnreg_ks {
     
        file { "checksat":
          ensure => file,
          path => '/usr/local/bin/checksat',
          mode => 0755,
          owner => 'root',
          group => 'root',
          source => 'puppet:///modules/rhnreg_ks/checksat',
          before => Rhn_register['dev1foster'],
        }         

        file { "unregister":
          ensure => file,
          path => '/usr/local/bin/unregister',
          mode => 0755,
          owner => 'root',
          group => 'root',
          source => 'puppet:///modules/rhnreg_ks/unregister',
          before => Rhn_register['dev1foster'],
        }         

          
        rhn_register { 'dev1foster':
         activationkeys => '2-rhel6-key',                                                                                                                  
         ensure         => 'present',                                                                                        
         username       => 'syseng_admin',                                                                                                                  
         password       => '4u2use2',                                                                                                                                                                    
         #profile_name   => 'dev1foster.promnetwork.com',                                                                                                                                                  
         server_url     => 'https://vasat.promnetwork.com/XMLRPC',                                                                                                                           
         #force         => true,                                                                                                                                                                       
         require        => [ File["checksat"], File["unregister"] ]
        }
}

