#!/usr/bin/python

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
              "ST: %s\r\n" % (SSDP_ST, ) + \
              "\r\n";

host="10.0.1.1"
sock = socket.socket(socket.AF_INET, socket.SOCK_DGRAM)
sock.bind((host,0))

sock.sendto(ssdpRequest, (SSDP_ADDR, SSDP_PORT))
print sock.recv(10000)
