package Physics::Unit::Script;

use strict;
use warnings;

use Getopt::Long;
use Physics::Unit ':ALL';
use Physics::Unit::Script::GenPages;

our $VERSION = '0.04_02';
$VERSION = eval $VERSION;

use base 'Exporter';
our @EXPORT_OK = qw/run_script getopt name_info/;

sub run_script {
  my $opts = getopt();

  if ($opts->{export}) {
    my @files = GenPages();
    print join(' ', @files), "\n";
  }

  if ($opts->{types}) {
    print "$_\n" for ListTypes;
  }

  if ($opts->{units}) {
    print "$_\n" for ListUnits;
  }

  foreach my $name (@ARGV) {
    name_info($name);
  }
}

sub getopt {
  my %opts;

  GetOptions(
    types  => \$opts{types},
    units  => \$opts{units},
    export => \$opts{export},
  );

  return \%opts;
}

my %classes = (
  3 => 'Type',
  2 => 'Unit',
  1 => 'Reserved',
  0 => 'Not Known',
  -1 => 'Derived',
);

sub name_info {
  my $name = shift;

  my $class = Physics::Unit::LookName($name);
  my $string = '';
  my $factor = '';

  if ($class == 1) {
    $string = 'NA';
    $factor = 'NA';
  } elsif ($class == 3) {
    $string = GetTypeUnit($name)->ToString;
  } else {
    my $unit = GetUnit($name);
    if ($class == 0 and defined $unit) {
      $class = -1;
    }
    my $type = GetTypeUnit($unit->type);
    $string = $unit->ToString;
    $factor = $unit->factor . " " . $type->ToString;
  }

  print <<INFO;
Name: $name
Class: $classes{$class}
Definition: $string
Conversion: $factor
INFO
}

1;

