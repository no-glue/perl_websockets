package StartThreadBroadcast;
use BroadcastConsumer;

sub startThreadBroadcast {
  my (@clients, @array) = @_;
  $broadcastConsumer = new BroadcastConsumer();
  while(1) {
    $broadcastConsumer->broadcast(@clients, @array);
  }
}

1;
__END__
