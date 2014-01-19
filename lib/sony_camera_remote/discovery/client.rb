require 'socket'
require 'system/getifaddrs'
require 'timeout'

module SonyCameraRemote
  module Discovery
    class Client
      include Socket::Constants

      class UnknownInterface < StandardError
        def initialize(offending, available)
          super("The interface '#{offending}' is not known. Possible values are #{available.join(', ')}.")
        end
      end

      SSDP_ADDR = {
        nil => '239.255.255.250',
        :ipv6_link_local => 'FF02::C',
        :ipv6_subnet => 'FF03::C',
        :ipv6_administrative => 'FF04::C',
        :ipv6_site_local => 'FF05::C',
        :ipv6_global => 'FF0E::C',
      }

      SSDP_PORT = 1900

      # TODO Move the enumeration and address lookup to its own class. This class does too much.
      def initialize(local_addrs = nil, timeout = 10, scope = nil)
        if local_addrs.nil?
          # Use all of the system's IP addresses
          @local_addrs = ip_addresses
        elsif local_addrs !~ /\b(?:\d{1,3}\.){3}\d{1,3}\b/ # http://www.regular-expressions.info/examples.html
          # Not exactly an IP address, so we treat it as interface name
          # TODO Support not just one, but a list of interfaces
          # TODO System.get_ifaddrs seems to return IPv4 addresses only
          if_addr = System.get_ifaddrs.fetch(local_addrs.to_sym) do |ip|
            raise UnknownInterface.new(ip, System.get_ifaddrs.keys)
          end[:inet_addr]

          @local_addrs = addr_info(if_addr)
        else
          @local_addrs = addr_info(local_addrs)
        end

        @addr = SSDP_ADDR[@scope]
        @timeout = timeout
      end

      def discover
        Array(@local_addrs).map do |local_addr|
          begin
            DeviceInfo.fetch(inquire(local_addr).location)
          rescue Errno::EADDRNOTAVAIL
            # TODO Notify observers instead of writing to STDOUT
            STDOUT.puts("Warning: Could not bind to #{local_addr.ip_address}.")
          rescue Errno::EINVAL
            STDOUT.puts("Warning: Address #{local_addr.ip_address} not supported.")
          rescue Timeout::Error
            STDOUT.puts("Warning: Timeout binding to #{local_addr.ip_address}.")
          end
        end.compact
      end

      private

      def inquire(local_addr)
        if local_addr.ipv4?
          socket = UDPSocket.new
        else
          socket = UDPSocket.new(Socket::AF_INET6)
        end

        socket.bind(local_addr.ip_address, 0)
        socket.send(Request.new(@addr, SSDP_PORT, @timeout).to_s, 0, @addr, SSDP_PORT)

        Timeout::timeout(@timeout) do
          Response.new(socket.recv(1000))
        end
      end

      def ip_addresses
        Socket.ip_address_list.reject{|a| a.ipv4_loopback? || a.ipv6_loopback? || a.ipv6_linklocal?}
      end

      def addr_info(if_addr)
        Addrinfo.new(Socket.sockaddr_in(SSDP_PORT, if_addr))
      end
    end
  end
end
