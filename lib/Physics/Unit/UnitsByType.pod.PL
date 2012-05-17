use strict;
use warnings;

use lib 'lib';
use Physics::Unit::Script::GenPages 'GenNameTable';

my $filename = shift;
open my $fh, ">", $filename or die "Could not open $filename for writing";

print $fh <<'PODHEADER';
=head1 NAME

Physics::Unit::UnitsByType

=head1 DESCRIPTION

This document lists the units provided by L<Physics::Unit> sorted by type. Since the POD standard does not do tables, they are formatted as HTML tables, therefore this is best viewed in a browser-based POD renderer. Note that the L<physics-unit> script can produce a very similar HTML file in the location of your choosing should this be more convenient.

=head1 UNITS

=begin html

PODHEADER

GenNameTable($fh);

print $fh <<'PODFOOTER';

=end html

=cut

PODFOOTER
