package SharedArray;
use threads;
use threads::shared;

sub new {
  my ($class) = @_;
  my @array :shared;
  bless \@array, $class;
  return \@array;
};

sub enqueue {
  my ($self, $item) = @_;
  push @$self, $item;
}

sub dequeue {
  my ($self) = @_;
  my $item = $@$self[0];
  shift @$self;
  return $item;
}

sub at {
  my ($self, $position) = @_;
  $item = @$self[$position];
  return $item;
}

sub len {
  my ($self) = @_;
  return length(@$self);
}

1;
__END__
