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
  for(my $i = 0; i < $clients->pending; $i++) {
    print $client $clients->peek($i);
  }
}

1;
__END__
