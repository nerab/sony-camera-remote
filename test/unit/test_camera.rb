require 'helper'
require 'json'

class CameraTest < MiniTest::Test
  def setup
    mocked('setup') do
      @camera = Camera.new('http://10.0.0.1:10000/sony/camera')
    end
  end

  def test_shootmode_movie
    assert_equal('movie', mocked{@camera.shootmode})
  end

  def test_shootmode_interval_still
    assert_equal('intervalstill', mocked{@camera.shootmode})
  end

  def test_shootmode_still
    assert_equal('still', mocked{@camera.shootmode})
  end

  def test_shoot
    uri = 'http://10.0.0.1:60152/pict140119_1918300000.JPG?%211234%21http%2dget%3a%2a%3aimage%2fjpeg%3a%2a%21%21%21%21%21'
    assert_equal([uri], mocked{@camera.shoot})
  end

  def test_supported_shootmodes
    assert_equal(["still", "movie", "intervalstill"], mocked{@camera.supported_shootmodes})
  end

  def test_available_methods
    assert_equal(33, mocked{@camera.available_methods}.size)
  end

  def test_application_info
    ai = mocked{@camera.application_info}
    assert_equal('Smart Remote Control', ai.name)
    assert_equal('2.0.0', ai.api_version)
  end
end
