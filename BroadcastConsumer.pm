package BroadcastConsumer;

sub new {
  my ($class) = @_;
  my $self = {
    _clients => [@_]
  };
  bless $self, $class;
  return $self;
}

sub broadcast {
  my ($self, $clients, $q) = @_;
  my $msg = $q->dequeue();
  print STDERR "msg: ".$msg."\n".@$clients."\n";
  for(my $i = 0; i < @$clients; $i++) {
    my $client = @$clients[$i];
    print $client $msg;
  }
}

1;
__END__
