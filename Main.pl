#!/usr/bin/env perl
use Socket;
use Server;
use Array;

$array = new Array();
# array
$server = new Server();
# server
my $sock;
# sock
my $client;
# client
socket($sock, AF_INET, SOCK_STREAM, $server->getProtocol()) or die sprintf("could not open the socket %d", $server->getProtocol());
# PF_INET connect to internet domain
# AF_INET ipv4 or ipv6
# $sock_STREAM tcp $sock_DGRAM udp
setsockopt($sock, SOL_SOCKET, SO_REUSEADDR, 1) or die "could not set socket option";
# SOL_$sockET set option on the socket not protocol
# mark the socket reusable
bind($sock, sockaddr_in($server->getPort(), INADDR_ANY)) or die "could not bind socket to port";
# bind socket to port, allowing any IP to connect
listen($sock, SOMAXCONN) or die "could not listen on port";
# start listening on port
while(accept($client, $sock)) {
  $array->push($client);
  $server->doHandshake($client);
}
close $client;
