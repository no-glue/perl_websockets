package Server;
use strict;
use Text::Trim;
use Digest::SHA1 qw(sha1_base64);
use MIME::Base64;
use utf8;
use threads;
use threads::shared;

my $BYTES_TO_READ = 2048;

sub new {
  my $class = shift;
  my $self = {
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

sub doHandshake {
  my ($self, $client) = @_;
  if($self->{_handshakeComplete} == 1) {
    return;
  }
  my $msg;
  recv($client, $msg, $BYTES_TO_READ, 0);
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
  my ($self, $client, @array) = @_;
  share(@array);
  lock(@array);
  my $msg;
  recv($client, $msg, $BYTES_TO_READ, 0);
  # print STDERR "Listen - client says: ".$msg."\n";
  # $msg = $self->unmask($msg);
  # no need to unmask for echo
  # print STDERR "Listen - unmasked message ".$msg."\n";
  push @array, $msg;
  cond_broadcast(@array);
}

sub unmask {
  my ($self, $msg) = @_;
  my $length = ord(substr($msg, 1, 1)) & 0x7f;
  # length - low 7 bits at position 1, mask 127, hex 0x7f
  # print STDERR "Unmask - message length ".$length."\n";
  my $mask = "";
  my $data = "";
  my $msgPlain = "";
  if($length == 126) {
    $mask = substr($msg, 4 , 4);
    $data = substr($msg, 8);
  } elsif($length == 127) {
    $mask = substr($msg, 10, 4);
    $data = substr($msg, 14);
  } else {
    $mask = substr($msg, 2, 4);
    $data = substr($msg, 6);
  }

  for(my $i = 0; $i < length($data); $i++) {
    $msgPlain .= substr($data, $i, 1) ^ substr($mask, $i % 4, 1);
  }

  return $msgPlain;
}

sub mask {
  my ($self, $msg) = @_;
  my $b1 = 0x80 | (0x1 & 0x0f);
  # first byte of header
  my $length = length($msg);
  my $header = "";
  if($length <= 125) {
    $header = pack("CC", $b1, $length);
  } elsif($length > 125 && $length < 65536) {
    $header = pack("CCn", $b1, 126, $length);
  } elsif($length >= 65536) {
    $header = pack("CCNN", $b1, 127, $length);
  }
  return $header.$msg;
}

1;
__END__
