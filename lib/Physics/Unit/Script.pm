package Physics::Unit::Script;

use strict;
use warnings;

use Getopt::Long;
use Physics::Unit ':ALL';

use parent 'Exporter';
our @EXPORT_OK = qw/getopt name_info/;

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

