package StartThread;
use Server;

sub startThread {
  my ($client, @array) = @_;
  my $server = new Server();
  $server->doHandshake($client);
  while(1) {
    $server->listen($client, @array);
  }
}

1;
__END__
