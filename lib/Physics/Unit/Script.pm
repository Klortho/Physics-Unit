package Physics::Unit::Script;

use strict;
use warnings;

use Physics::Unit ':ALL';
use Physics::Unit::Script::GenPages;

our $VERSION = '0.04_02';
$VERSION = eval $VERSION;

use base 'Exporter';
our @EXPORT_OK = qw/run_script name_info/;


sub run_script {
  my $opts = shift;

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
    my $n = GetUnit($name);
    if ($class == 0 && defined $n) {
        $class = -1;
    }

    print "Name:  $name\n" .
          "Class:  $classes{$class}\n";

    if ($class == -1 || $class == 2 || $class == 3) {
        print "Type:  " . $n->type() . "\n" .
              "Definition:  " . $n->def() . "\n" .
              "Expanded:  " . $n->expanded() . "\n";
    }
  
    print "\n";
}

1;

