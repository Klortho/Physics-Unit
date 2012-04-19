package Physics::Unit::Acceleration;
use strict;
use Physics::Unit::Scalar;
use vars qw( $VERSION @ISA $MyUnit );
$VERSION = '0.05';
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('m/s^2');

1;

package Physics::Unit::Area;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('are');

1;

package Physics::Unit::Capacitance;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('farad');

1;

package Physics::Unit::Charge;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('coulomb');

1;

package Physics::Unit::Conductance;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('siemens');

1;

package Physics::Unit::Current;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('ampere');

1;

package Physics::Unit::Data;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('bit');

1;
package Physics::Unit::Distance;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('meter');

1;

package Physics::Unit::Dose;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('gray');

1;

package Physics::Unit::Dimensionless;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('unity');

1;

package Physics::Unit::Electric_potential;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('volt');

1;

package Physics::Unit::Energy;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('joule');

1;

package Physics::Unit::Force;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('newton');

1;

package Physics::Unit::Frequency;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('hertz');

1;

package Physics::Unit::Inductance;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('henry');

1;

package Physics::Unit::Luminosity;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('candela');

1;

package Physics::Unit::Magnetic_field;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('tesla');

1;

package Physics::Unit::Magnetic_flux;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('weber');

1;

package Physics::Unit::Mass;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('gram');

1;

package Physics::Unit::Money;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('us_dollar');

1;

package Physics::Unit::Power;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('watt');

1;

package Physics::Unit::Pressure;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('pascal');

1;

package Physics::Unit::Resistance;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('ohm');

1;

package Physics::Unit::Speed;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('mps');

1;

package Physics::Unit::Substance;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('mole');

1;

package Physics::Unit::Temperature;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('kelvin');

1;

package Physics::Unit::Time;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('second');

1;

package Physics::Unit::Volume;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('liter');

1;
__END__

=head1 NAME

Physics::Unit::ScalarSubtypes - User defined dimensional units.

=head1 AUTHOR

Chris Maloney <Dude@chrismaloney.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2002-2003 by Chris Maloney

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
