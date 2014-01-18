require 'helper'
require 'json'

class DeviceInfoTest < MiniTest::Test
  def setup
    @cameras = mocked('setup') do
      #Camera.discover
    end
  end

  def test_size
    skip
    assert_equal(1, @cameras.size)
  end
end
