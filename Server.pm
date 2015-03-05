package Server;
use strict;
use Socket;

sub new {
  my $class = shift;
  my $self = {
    _port => 8080,
    _protocol => getprotobyname("tcp")
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

1;
__END__
