# extremely helpful documentation
# https://github.com/puppetlabs/puppet-specifications/blob/master/language/func-api.md#the-4x-api
Puppet::Functions.create_function(:rhn_keys) do
  dispatch :rhn_keys do
    required_param 'Hash[String[1],String[1]]', :reg_map
    required_param 'Array[String[1]]', :key_criteria
    required_param 'Hash[String, Any]', :facts
  end
  # given a reg_map like:
  # {
  #   'rhel6' => '12393828293',
  #   'physical' => '128283828',
  #   'vmware'   => '3882838223',
  #   'rhel7'    => '1383823923'
  # }
  # and a key_criteria ['virtual', 'operatingsystemrelease']
  # Returns a comma seperated list of rhn registration keys by
  # searching through the reg_map to find fact values that match
  # the nodes fact value given the criteria
  # produces output like: '12393828293,128283828'
  def rhn_keys(reg_map, key_criteria,facts)
    # loop around each key critera and query the reg_map to see
    # if the fact value is associated with an RHN key
    reg_keys = key_criteria.map do |fact|
      reg_map[facts[fact]]
    end
    # for each RHN key found, join them into a single string separate by commas
    reg_keys.compact.join(',')
  end
end
