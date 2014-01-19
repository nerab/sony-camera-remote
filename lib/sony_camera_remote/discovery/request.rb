require 'erb'

module SonyCameraRemote
  module Discovery
    class Request
      TEMPLATE = File.read(File.join(File.dirname(__FILE__), 'm_search.erb'))
      attr_reader :host, :port, :timeout

      def initialize(host, port, timeout)
        @host, @port, @timeout = host, port, timeout
      end

      def to_s
        b = binding
        result = ERB.new(TEMPLATE, 0, "").result(b)
        result.split("\n").join("\r\n") << ("\r\n" * 2)
      end
    end
  end
end
