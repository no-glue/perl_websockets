package Array;
use strict;
sub new {
  my $class = shift;
  my $self = {
    _items => [@_]
  };
  bless $self, $class;
  return $self;
}

sub push {
  my ($self, $item) = @_;
  push(@{$self->{_items}}, $item);
}

sub get {
  my ($self) = @_;
  return @{$self->{_items}}[0];
}

sub pop {
  my ($self) = @_;
  pop(@{$self->{_items}});
}

1;
__END__
