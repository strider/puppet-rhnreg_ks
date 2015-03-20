# rhn_system_id.rb
require 'rexml/document'

Facter.add(:rhn_system_id) do
  confine :osfamily => 'RedHat'
  setcode do
    value = nil

    filepath = '/etc/sysconfig/rhn/systemid'

    if FileTest.file?(filepath)
      begin
        f = File.open(filepath)
        doc = REXML::Document.new f
        f.close
        value = REXML::XPath.match( doc, "/params/param/value/struct/member[name='system_id']/value/string")[0].text
      rescue
        value = nil
      end
    end
    value
  end
end
