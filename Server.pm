package Server;
use strict;
use Socket;

sub new {
  my $class = shift;
  my $self = {
    _port => 8080,
    _protocol => getprotobyname("tcp"),
    _httpReqKey => "Sec-WebSocket-Key: ",
    _guidString => "258EAFA5-E914-47DA-95CA-C5AB0DC85B11",
    _httpReqEnd => "\r\n\r\n"
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
