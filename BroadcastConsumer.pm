package BroadcastConsumer;

sub new {
  my ($class) = @_;
  my $self = {};
  bless $self, $class;
  return $self;
}

sub broadcast {
  my ($self, $clients, $q) = @_;
  my $msg = $q->dequeue();
  for(my $i = 0; i < $clients->len(); $i++) {
    print $client $clients->at($i);
  }
}

1;
__END__
