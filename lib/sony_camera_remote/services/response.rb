module SonyCameraRemote
  module Discovery
    class Response
      def initialize(raw)
        raw.each_line do |line|
          if match = line.match(/^LOCATION: (.*)/)
            @location, _ = match.captures
          end
        end
      end

      def location
        @location
      end
    end
  end
end
