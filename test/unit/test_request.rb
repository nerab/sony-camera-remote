require 'helper'

class RequestTest < MiniTest::Test
  def setup
    @request = Request.new('239.255.255.250', 1900, 1)
  end

  def test_request
    assert_equal(fixture('discovery_request.txt'), @request.to_s)
  end
end
