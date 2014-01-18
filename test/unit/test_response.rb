require 'helper'
require 'json'

class ResponseTest < MiniTest::Test
  def setup
    @response = SonyCameraRemote::Discovery::Response.new(fixture('discovery_response.txt'))
  end

  def test_location
    assert_equal('http://10.0.0.1:64321/DmsRmtDesc.xml', @response.location)
  end
end
