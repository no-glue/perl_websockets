package BroadcastConsumer;
use threads;
use threads::shared;

sub new {
  my ($class) = @_;
  my $self = {};
  bless $self, $class;
  return $self;
}

sub broadcast {
  my ($self, @clients, @array) = @_;
  cond_wait(@array);
  lock(@array);
  my $msg = $array[0];
  pop @array;
  for(my $i = 0; i < length(@clients); $i++) {
    my $client = $clients[$i];
    print $client $msg;
  }
  cond_broadcast(@array);
}

1;
__END__
