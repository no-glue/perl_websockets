package Server;
use strict;
use Socket;

sub new {
  my $class = shift;
  my $self = {
    _port => 8080,
    _protocol => getprotobyname("tcp"),
    _responseHeader => "HTTP/1.1 101 Switching Protocols".
    "Upgrade: websocket".
    "Connection: Upgrade".
    "Sock-WebSocket-Accept: %s\r\n\r\n",
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

sub doHandshake {
  my ($self, $client, $socket) = @_;
  while(my $line = <$socket>) {
    print $line;
  }
}

1;
__END__
