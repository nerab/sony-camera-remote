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

    def initialize(uri)
      self.class.base_uri(URI(uri).to_s)

      ai = application_info
      raise IncompatibleAPIVersion(API_VERSION, ai.api_version) if API_VERSION != ai.api_version
    end

    def shootmode
      options = {:body => DEFAULT_OPTIONS.merge({:method => 'getShootMode'}).to_json}
      self.class.post('', options)['result'].first
    end

    def supported_shootmodes
      options = {:body => DEFAULT_OPTIONS.merge({:method => 'getSupportedShootMode'}).to_json}
      self.class.post('', options)['result'].first
    end

    def application_info
      options = {:body => DEFAULT_OPTIONS.merge({:method => 'getApplicationInfo'}).to_json}
      result = self.class.post('', options)['result']
      ApplicationInfo.new(result.first, result.last)
    end

    def available_methods
      options = {:body => DEFAULT_OPTIONS.merge({:method => 'getAvailableApiList'}).to_json}
      self.class.post('', options)['result'].first
    end

    # blocking
    def shoot
      options = {:body => DEFAULT_OPTIONS.merge({:method => 'actTakePicture'}).to_json}
      self.class.post('', options)['result'].first
    end
  end
end
