require 'erb'

module SonyCameraRemote
  module Discovery
    class Request
      attr_reader :host, :port, :timeout

      def initialize(host, port, timeout)
        @host, @port, @timeout = host, port, timeout
      end

      def to_s
        b = binding
        result = ERB.new(File.read(File.join(File.dirname(__FILE__), 'm_search.erb')), 0, "").result(b)
        result.split("\n").join("\r\n") << ("\r\n" * 2)
      end
    end
  end
end

# TODO DATA.gets
#__END__
#hello world!
