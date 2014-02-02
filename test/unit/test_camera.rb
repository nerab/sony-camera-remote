require 'helper'
require 'json'

class CameraTest < MiniTest::Test
  def setup
    mocked('setup') do
      @camera = Camera.new('http://10.0.0.1:10000/sony/camera')
    end
  end

  def test_shootmode_movie
    assert_equal(:movie, mocked{@camera.mode})
  end

  def test_shootmode_interval_still
    assert_equal(:intervalstill, mocked{@camera.mode})
  end

  def test_shootmode_still
    assert_equal(:still, mocked{@camera.mode})
  end

  def test_shoot
    uri = ['http://10.0.0.1:60152/pict140202_0044410001.JPG?%211234%21http%2dget%3a%2a%3aimage%2fjpeg%3a%2a%21%21%21%21%21']
    assert_equal(uri, mocked{@camera.record})
  end

  def test_supported_shootmodes
    assert_equal([:still, :movie, :intervalstill], mocked{@camera.supported_modes})
  end

  def test_available_methods
    assert_equal(33, mocked{@camera.available_methods}.size)
  end

  def test_application_info
    ai = mocked{@camera.application_info}
    assert_equal('Smart Remote Control', ai.name)
    assert_equal('2.0.0', ai.api_version)
  end

  def test_shoot_fails_in_movie_mode
    mocked{
      assert_equal(:movie, @camera.mode)
      @camera.mode = :still
      assert_equal(:still, @camera.mode)
    }
  end

  def test_available
    assert(mocked{@camera.available?(:still)})
    assert(mocked{@camera.available?(:intervalstill)})
    assert(mocked{@camera.available?(:movie)})
  end

  def test_not_available
    refute(mocked{@camera.available?(:intervalmovie)})
  end

  def test_supported
    assert(mocked{@camera.supported?(:still)})
    assert(mocked{@camera.supported?(:intervalstill)})
    assert(mocked{@camera.supported?(:movie)})
  end

  def test_not_supported
    refute(mocked{@camera.supported?(:stillmovie)})
  end

  def test_switch_mode_and_shoot
    url = ['http://10.0.0.1:60152/pict140202_0038410000.JPG?%211234%21http%2dget%3a%2a%3aimage%2fjpeg%3a%2a%21%21%21%21%21']

    mocked{
      assert_equal(:movie, @camera.mode)
      @camera.mode = :still
      assert_equal(:still, @camera.mode)
      assert_equal(url, @camera.record)
    }
  end
end
