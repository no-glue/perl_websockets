package StartThread;
use Server;

sub startThread {
  my ($client) = @_;
  my $server = new Server();
  $server->doHandshake($client);
  while(1) {
    $server->listen($client);
  }
}

1;
__END__
