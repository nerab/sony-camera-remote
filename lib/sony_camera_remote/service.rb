require 'uri'

module SonyCameraRemote
  module Services
    class Service < Struct.new(:id, :type, :scpd_url, :control_url, :event_sub_url)
    end

    class ContentDirectoryService < Service

    end

    class ConnectionManagerService < Service

    end

    class ScalarWebAPIService < Service
      attr_accessor :actionlist_url, :access_type

      def base_uri
        URI([actionlist_url, type].join('/'))
      end
    end
  end
end
