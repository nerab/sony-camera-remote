module SonyCameraRemote
  class Camera
    class << self
      def discover(local_ips = nil)
        Discovery.discover(local_ips)
      end
    end
  end
end
