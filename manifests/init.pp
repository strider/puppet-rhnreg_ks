class rhnreg_ks {
        rhn_register { 'title':
         activationkeys => 'activationkey',                                                                                                                  
         ensure         => 'present',                                                                                        
         username       => 'username',                                                                                                                  
         password       => 'password',                                                                                                                                                            
         profile_name   => 'profilename',                                                                                                                                        
         server_url     => 'serverurl/XMLRPC',                                                                                                                           
         #force         => true,                                                                                                                                                                    
        }
}

