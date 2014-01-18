require 'helper'
require 'json'

class CameraTest < MiniTest::Test
  def setup
    @cameras = mocked('setup') do
      Camera.discover
    end
  end

  def test_size
    assert_equal(1, @cameras.size)
  end
end
