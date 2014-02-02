require 'httparty'
require 'json'

module SonyCameraRemote
  class Camera
    API_VERSION = '2.0.0'

    include HTTParty

    DEFAULT_OPTIONS = {:version => '1.0', :params => [], :id => 1}

    class ApplicationInfo < Struct.new(:name, :api_version)
      def to_s
        "#{name} v#{api_version}"
      end
    end

    class IncompatibleAPIVersion < StandardError
      attr_reader :supported, :actual

      def initialize(supported, actual)
        super("The camera provides API version #{actual}, but this library only supports #{supported}.")
        @supported, @actual = supported, actual
      end
    end

    def initialize(uri, debug = nil)
      self.class.base_uri(URI(uri).to_s)
      self.class.debug_output(debug) unless debug.nil?

      ai = application_info
      raise IncompatibleAPIVersion(API_VERSION, ai.api_version) if API_VERSION != ai.api_version
    end

    def application_info
      result = request('getApplicationInfo')
      ApplicationInfo.new(result.first, result.last)
    end

    def available_methods
      request('getAvailableApiList').first
    end

    #
    # Take a picture or start recording.
    #
    # This method behaves like pressing the shutter release button:
    #
    #   * if the camera is in movie mode, it will start recording
    #   * if the camera is in still mode, it will take a picture
    #   * if the camera is in intervallstill mode, it will start the interval recording
    #
    def record
      case mode
        when :movie
          request('startMovieRec').first
        else
          request('actTakePicture').first
      end
    end

    def supported?(mode)
      supported_modes.include?(mode)
    end

    def available?(mode)
      available_modes.last.include?(mode)
    end

    def mode=(new_mode)
      request('setShootMode', Array(new_mode).first).first == 0
    end

    def mode
      request('getShootMode').first.to_sym
    end

    def supported_modes
      request('getSupportedShootMode').first.map{|m| m.to_sym}
    end

    def available_modes
      result = request('getAvailableShootMode')
      [result.first.to_sym, result.last.map{|m| m.to_sym}]
    end

    private

    def assert_supported(mode)
      raise "#{mode} is not supported by this camera" unless supported?(mode)
    end

    def assert_available(mode)
      raise "#{mode} is not available right now" unless available?(mode)
    end

    def assert_mode(mode)
      raise "Camera is not in #{mode} but in #{self.mode} mode." unless self.mode == mode
    end

    def request(method, params = [])
      options = {:body => DEFAULT_OPTIONS.merge({:method => method, :params => Array(params)}).to_json}
      result = self.class.post('', options)

      if result['result']
        result['result']
      else
        raise Errors::CODE[result['error'].first] || "Unknown response: #{result}"
      end
    end
  end
end
