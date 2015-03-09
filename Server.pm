package Server;
use strict;
use Text::Trim;
use Digest::SHA1 qw(sha1_base64);
use MIME::Base64;
use utf8;

sub new {
  my $class = shift;
  my $self = {
    _port => 8080,
    _protocol => getprotobyname("tcp"),
    _responseHeader => "HTTP/1.1 101 Web Socket Protocol Handshake\r\n".
    "Upgrade: WebSocket\r\n".
    "Connection: Upgrade\r\n".
    "sec-websocket-accept: %s\r\n\r\n",
    _guidString => "258EAFA5-E914-47DA-95CA-C5AB0DC85B11",
    _handshakeComplete => 0
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
  my ($self, $client) = @_;
  if($self->{_handshakeComplete} == 1) {
    return;
  }
  my $msg;
  recv($client, $msg, 2048, 0);
  # print STDERR "Handshake - received from client: ".$msg."\n";
  my @matches = $msg =~ /Sec-WebSocket-Key:\s+(.*?)[\n\r]+/;
  my $key = trim(shift @matches);
  # print STDERR "Handshake - received key from client: ".$key."\n";
  my $keyEncoded = sha1_base64($key.$self->{_guidString})."=";
  # print STDERR "Handshake - sending to client: ".sprintf($self->{_responseHeader}, $keyEncoded)."\n";
  print $client sprintf($self->{_responseHeader}, $keyEncoded);
  $self->{_handshakeComplete} = 1;
}

sub listen {
  my ($self, $client) = @_;
  my $msg;
  recv($client, $msg, 2048, 0);
  # print STDERR "Listen - client says: ".$msg."\n";
  print $client $msg;
}

1;
__END__
