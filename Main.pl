#!/usr/bin/env perl
use IO::Socket::INET;
use threads("yield", 
"stack_size" => 64 * 4096, 
"exit" => "threads_only", 
"stringify");
use threads::shared;
use StartThreadServer;

@array = ();
share(@array);
# array
@clients = ();
# clients
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
  push @clients, $clientSocket;
  $thread = threads->create("StartThreadServer::startThread", $clientSocket, @array);
  $thread->detach();
}
