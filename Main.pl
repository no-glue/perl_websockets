#!/usr/bin/env perl
use IO::Socket::INET;
use Server;
use Array;

$array = new Array();
# array
$server = new Server();
# server
$socket = new IO::Socket::INET (
  LocalHost => '127.0.0.1',
  LocalPort => '8080',
  Proto => 'tcp',
  Listen => 10,
  Reuse => 1
) or die "Oops: $!\n";
print STDERR "Server is up and running\n";
while(1) {
  $clientSocket = $socket->accept();
  if(!$server->{_handshakeComplete}) {
    $server->doHandshake($clientSocket);
  }
}
