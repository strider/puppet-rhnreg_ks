class rhnreg_ks {
        rhn_register { 'title':
        activationkeys => 'satellite-key',
        ensure         => 'present or absent',
        username       => 'user to add/delte server accounts',
        password       => 'password for user',
        profile_name   => 'This will setup how the server is named in the satellite server or it will use `hostname`',
        server_url     => 'server url up to the XMLRPC',
        #force         => 'set to true or false if you want to force an update every run',
        }
}
