require 'helper'
require 'json'

class DeviceInfoTest < MiniTest::Test
  def setup
    @device = mocked('setup') do
      DeviceInfo.fetch('http://10.0.0.1:64321/DmsRmtDesc.xml')
    end
  end

  def test_services
    assert_equal(6, @device.services.size)
    assert_equal(1, @device.services.select{|s| 'camera' == s.type}.size)
  end

  def test_camera_service
    camera_service = @device.services.select{|s| 'camera' == s.type}.first
    assert_equal('http://10.0.0.1:10000/sony', camera_service.actionlist_url)
  end

  def test_attributes
    assert_equal('HDR-AS30V', @device.name)
    assert_equal('Sony Corporation', @device.manufacturer.name)
    assert_equal('http://www.sony.com/', @device.manufacturer.url)
    assert_equal('SonyImagingDevice', @device.model.name)
    assert_equal('SonyDigitalMediaServer', @device.model.description)
    assert_equal('http://www.sony.net/', @device.model.url)
  end
end
