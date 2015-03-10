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
  lock(@$self);
  push @$self, $item;
  cond_signal(@$self);
}

sub dequeue {
  my ($self) = @_;
  lock(@$self);
  cond_wait(@$self) until @$self > 0;
  my $item = @$self[0];
  shift @$self;
  return $item;
}

sub at {
  my ($self, $position) = @_;
  lock(@$self);
  $item = @$self[$position];
  return $item;
}

sub len {
  my ($self) = @_;
  lock(@$self);
  cond_wait(@$self) until @$self > 0;
  return @$self;
}

1;
__END__
