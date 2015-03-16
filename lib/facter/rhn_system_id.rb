# rhn_system_id.rb
require 'nokogiri'

Facter.add(:rhn_system_id) do
  confine :osfamily => 'RedHat'
  setcode do
    value = nil

    filepath = '/etc/sysconfig/rhn/systemid'

    if FileTest.file?(filepath)
      begin
        f = File.open(filepath)
        doc = Nokogiri::XML(f)
        f.close
        value = doc.xpath("/params/param/value/struct/member[name='system_id']/value/string")[0].content
      rescue
        value = nil
      end
    end
    value
  end
end
