#!/usr/bin/python

# from https://github.com/crquan/work-on-sony-apis/blob/master/search-nex.py
# Added bind() in order to specify which local address (interface) to use

import sys
import socket
import time

SSDP_ADDR = "239.255.255.250";
SSDP_PORT = 1900;
SSDP_MX = 1;
SSDP_ST = "urn:schemas-sony-com:service:ScalarWebAPI:1";

ssdpRequest = "M-SEARCH * HTTP/1.1\r\n" + \
              "HOST: %s:%d\r\n" % (SSDP_ADDR, SSDP_PORT) + \
              "MAN: \"ssdp:discover\"\r\n" + \
              "MX: %d\r\n" % (SSDP_MX, ) + \
              "ST: %s\r\n" % (SSDP_ST, ) + "\r\n";

sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind(("10.0.1.1", 0))

sock.sendto(ssdpRequest, (SSDP_ADDR, SSDP_PORT))
print sock.recv(1000)
