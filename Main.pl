#!/usr/bin/env perl
use Socket;
use Server;

$server = new Server();

socket(SOCK, PF_INET, SOCK_STREAM, $server->getProtocol()) or die sprintf("could not open the socket %d", $server->getProtocol());
# PF_INET connect to internet domain
# SOCK_STREAM tcp SOCK_DGRAM udp
setsockopt(SOCK, SOL_SOCKET, SO_REUSEADDR, 1) or die "could not set socket option";
# SOL_SOCKET set option on the socket not protocol
# mark the socket reusable
bind(SOCK, sockaddr_in($server->getPort(), INADDR_ANY)) or die "could not bind socket to port";
# bind socket to port, allowing any IP to connect
listen(SOCK, SOMAXCONN) or die "could not listen on port";
# start listening on port
while(accept(CLIENT, SOCK)) {
  print CLIENT "HTTP/1.1 200 OK\r\n" .
               "Content-Type: text/html; charset=UTF-8\r\n\r\n" .
               "<html><head><title>Goodbye, world!</title></head><body>Goodbye, world!</body></html>\r\n";
  close CLIENT;
}
