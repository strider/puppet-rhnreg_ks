Puppet::Type.newtype(:rhn_channel) do
  ensurable

  newparam(:channel, :namevar => true) do
    desc "The channel name."
  end

  newparam(:username) do
    desc "The rhn/spacewalk user."
    validate do |value|
      #NB. Allowable usernames taken from spacewalk source code.
      #username contains ascii chars minus whitespace, &, +, %, ', `, ", =, #
      fail("Invalid username #{value}. Non ascii characters not permitted") unless /^[\x00-\x7F]+$/.match(value)
      fail("Invalid username #{value}. Whitespace not permitted") if value =~ /\s/
      illegal_chars = [ '&', '+', '%', '\'', '`', '"', '=', '#' ]
      illegal_chars.each { |x|
        fail("Invalid username #{value}. '#{x}' character not permitted") if value =~ /#{Regexp.escape(x)}/
      }
    end
  end

  newparam(:password) do
    desc "The rhn/spacewalk password."
  end

  validate do
    if self[:ensure] #Without this if, puppet resource rhn_channel will fail
      if self[:password].nil? or self[:username].nil?
        raise ArgumentError, 'username and password are required when adding or removing channels'
      end
    end
  end

end
