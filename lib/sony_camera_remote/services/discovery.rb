require 'erb'
require 'socket'
require 'system/getifaddrs'
require 'timeout'

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

    class Client
      include Socket::Constants

      class UnknownInterface < StandardError
        def initialize(offending, available)
          super("The interface '#{offending}' is not known. Possible values are #{available.join(', ')}.")
        end
      end

      SSDP_ADDR = '239.255.255.250'
      SSDP_PORT = 1900
      SSDP_TIMEOUT = 10 # sec

      def initialize(local_addrs = nil, timeout = 1000)
        if local_addrs.nil?
          # Use all of the system's IP addresses
          @local_addrs = System.get_ifaddrs.map{|k,v| v[:inet_addr]}
        elsif local_addrs !~ /\b(?:\d{1,3}\.){3}\d{1,3}\b/ # http://www.regular-expressions.info/examples.html
          # Not exactly an IP address, so we treat it as interface name
          @local_addrs = System.get_ifaddrs.fetch(local_addrs.to_sym) do |ip|
            raise UnknownInterface.new(ip, System.get_ifaddrs.keys)
          end[:inet_addr]
        else
          @local_addrs = local_addrs
        end
      end

      def discover
        Array(@local_addrs).map do |local_addr|
          begin
            fetch(local_addr)
          rescue Errno::EADDRNOTAVAIL
            # TODO Notify observers instead of writing to STDOUT
            STDOUT.puts("Warning: Could not bind to #{local_addr}.")
          rescue Timeout::Error
            STDOUT.puts("Warning: Timeout binding to #{local_addr}.")
          end
        end
      end

      private

      def fetch(local_addr)
        socket = UDPSocket.new
        socket.bind(local_addr, 0)
        socket.send(Request.new(SSDP_ADDR, SSDP_PORT, SSDP_TIMEOUT).to_s, 0, SSDP_ADDR, SSDP_PORT)

        Timeout::timeout(SSDP_TIMEOUT) do
          Response.new(socket.recv(1000))
        end
      end

      # Could use this instead of System.get_ifaddrs, but we wouldn't get the interface names
      def ifaddrs
        Socket.ip_address_list.reject{|a| a.ipv4_loopback? || a.ipv6_loopback? || a.ipv6_linklocal?}.map{|a| a.ip_address}
      end
    end
  end
end
