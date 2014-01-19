require 'helper'
require 'json'

class DeviceInfoTest < MiniTest::Test
  def setup
    @device = mocked('setup') do
      DeviceInfo.fetch('http://10.0.0.1:64321/DmsRmtDesc.xml')
    end
  end

  def test_device_attributes
    assert_equal('HDR-AS30V', @device.name)
    assert_equal('Sony Corporation', @device.manufacturer.name)
    assert_equal('http://www.sony.com/', @device.manufacturer.url)
    assert_equal('SonyImagingDevice', @device.model.name)
    assert_equal('SonyDigitalMediaServer', @device.model.description)
    assert_equal('http://www.sony.net/', @device.model.url)
  end

  def test_services
    assert_equal(6, @device.services.size)
  end

  def test_service
    service = @device.services['camera']
    refute_nil(service)
    assert_equal(URI('http://10.0.0.1:10000/sony/camera'), service.base_uri)
  end

  def test_guide_service
    service = @device.services['guide']
    refute_nil(service)
    assert_equal(URI('http://10.0.0.1:10000/sony/guide'), service.base_uri)
  end

  def test_accessControl_service
    service = @device.services['accessControl']
    refute_nil(service)
    assert_equal(URI('http://10.0.0.1:10000/sony/accessControl'), service.base_uri)
  end

  def test_ContentDirectory_service
    service = @device.services['urn:upnp-org:serviceId:ContentDirectory']
    refute_nil(service)
    assert_equal('urn:schemas-upnp-org:service:ContentDirectory:1', service.type)
    assert_equal('urn:upnp-org:serviceId:ContentDirectory', service.id)
    assert_equal('/CdsDesc.xml', service.scpd_url)
    assert_equal('/upnp/control/ContentDirectory', service.control_url)
    assert_equal('/upnp/event/ContentDirectory', service.event_sub_url)
  end

  def test_ConnectionManager_service
    service = @device.services['urn:upnp-org:serviceId:ConnectionManager']
    refute_nil(service)
    assert_equal('urn:schemas-upnp-org:service:ConnectionManager:1', service.type)
    assert_equal('urn:upnp-org:serviceId:ConnectionManager', service.id)
    assert_equal('/CmsDesc.xml', service.scpd_url)
    assert_equal('/upnp/control/ConnectionManager', service.control_url)
    assert_equal('/upnp/event/ConnectionManager', service.event_sub_url)
  end

  def test_ScalarWebAPI_service
    service = @device.services['urn:schemas-sony-com:serviceId:ScalarWebAPI']
    refute_nil(service)
    assert_equal('urn:schemas-sony-com:service:ScalarWebAPI:1', service.type)
    assert_equal('urn:schemas-sony-com:serviceId:ScalarWebAPI', service.id)
    assert_equal('/ScalarWebApiDesc.xml', service.scpd_url)
    refute(service.control_url)
    refute(service.event_sub_url)
  end
end
