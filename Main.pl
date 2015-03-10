#!/usr/bin/env perl
use IO::Socket::INET;
use threads("yield", 
"stack_size" => 64 * 4096, 
"exit" => "threads_only", 
"stringify");
use Thread::Queue;
use Server;
use BroadcastConsumer;

my $q = Thread::Queue->new();
# q
my $clients = Thread::Queue->new();
# clients
$thread = threads->create(sub {
  $broadcastConsumer = new BroadcastConsumer();
  while(1) {
    $broadcastConsumer->broadcast($clients, $q);
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
  my $clientSocket = $socket->accept();
  $clients->enqueue($clientSocket);
  $thread = threads->create(sub {
    $server = new Server();
    $server->doHandshake($clientSocket);
    while(1) {
      $server->listen($clientSocket, $q);
    }
  });
  $thread->detach();
}
