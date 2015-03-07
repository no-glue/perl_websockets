package Server;
use strict;
use Socket;
use Text::Trim;
use Digest::SHA1 qw(sha1_base64);
use MIME::Base64;
use utf8;

sub new {
  my $class = shift;
  my $self = {
    _port => 8080,
    _protocol => getprotobyname("tcp"),
    _responseHeader => "HTTP/1.1 101 Switching Protocols\r\n".
    "Upgrade: websocket\r\n".
    "Connection: Upgrade\r\n".
    "Sock-WebSocket-Accept: %s\r\n\r\n",
    _guidString => "258EAFA5-E914-47DA-95CA-C5AB0DC85B11"
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
  my $msg;
  recv($client, $msg, 2048, 0);
  my @matches = $msg =~ /Sec-WebSocket-Key:\s+(.*?)[\n\r]+/;
  my $key = trim(shift @matches);
  my $keyEncoded = sha1_base64($key.$self->{_guidString});
  print $client sprintf($self->{_responseHeader}, $keyEncoded);
  print STDERR "sent response header";
  # sent response header
  my $serverSays = "hello\r\n";
  my $serverSaysEncoded = encode_base64(utf8::encode($serverSays));
  my $serverSaysEncodedLength = length($serverSaysEncoded);
  my @chars = split("", $serverSaysEncoded);
  unshift(@chars, chr($serverSaysEncodedLength));
  unshift(@chars, chr(0x81));
  my $sayToClient = join("", @chars);
  print STDERR $sayToClient." and something";
  print $client $sayToClient;
  recv($client, $msg, 2048, 0);
  print STDERR $msg;
}

sub listen {
  my ($self, $client) = @_;
  my $msg;
  recv($client, $msg, 2048, 0);
  print STDERR $msg;
  print $client $msg;
}

1;
__END__
