#!/usr/bin/env perl
use IO::Socket::INET;
use threads("yield", 
"stack_size" => 64 * 4096, 
"exit" => "threads_only", 
"stringify");
use threads::shared;
use Server;
use BroadcastConsumer;

@array = ();
share(@array);
# array
@clients = ();
# clients
$thread = threads->create(sub {
  $broadcastConsumer = new BroadcastConsumer();
  while(1) {
    $broadcastConsumer->broadcast(@clients, @array);
  }
});
$thread->detach();
# broadcastConsumer
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
  $thread = threads->create(sub {
    $server = new Server();
    $server->doHandshake($clientSocket);
    while(1) {
      $server->listen($clientSocket, @array);
    }
  });
  $thread->detach();
}
