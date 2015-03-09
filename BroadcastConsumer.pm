package BroadcastConsumer;

sub new {
  my ($class) = @_;
  my $self = {
    _clients => [@_]
  };
  bless $self, $class;
  return $self;
}

sub broadcast {}

1;
__END__
