package Server;

sub new {
  my $class = shift;
  my $port = shift;
  my $protocol = shift;
  my $self = {
    _port => $port if defined($port) else 8080,
    _protocol => $protocol if defined($protocol) else getprotobyname("tcp")
  };
  bless $self, $class;
  return $self;
}

sub getPort {
  my ($self) = @_;
  return $self->{_port};
}

sub getProtocol {
  my ($self) = @_;
  return $self->{_protocol};
}
