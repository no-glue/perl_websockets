package BroadcastConsumer;

sub new {
  my ($class) = @_;
  my $self = {};
  bless $self, $class;
  return $self;
}

sub broadcast {
  my ($self, $clients, $q) = @_;
  print STDERR $self."\n".$clients."\n".$q."\n";
  my $msg = $q->dequeue();
  for(my $i = 0; i < length(@clients); $i++) {
    my $client = $clients[$i];
    print $client $msg;
  }
}

1;
__END__
