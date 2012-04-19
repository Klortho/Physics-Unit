package Physics::Unit::Acceleration;
use strict;
use Physics::Unit::Scalar;
use vars qw( $VERSION @ISA $MyUnit );
$VERSION = '0.05';
$VERSION = eval $VERSION;

@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('m/s^2');


package Physics::Unit::Area;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('are');


package Physics::Unit::Capacitance;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('farad');


package Physics::Unit::Charge;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('coulomb');


package Physics::Unit::Conductance;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('siemens');


package Physics::Unit::Current;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('ampere');


package Physics::Unit::Data;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('bit');


package Physics::Unit::Distance;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('meter');


package Physics::Unit::Dose;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('gray');


package Physics::Unit::Dimensionless;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('unity');


package Physics::Unit::Electric_potential;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('volt');


package Physics::Unit::Energy;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('joule');


package Physics::Unit::Force;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('newton');


package Physics::Unit::Frequency;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('hertz');


package Physics::Unit::Inductance;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('henry');


package Physics::Unit::Luminosity;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('candela');


package Physics::Unit::Magnetic_field;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('tesla');


package Physics::Unit::Magnetic_flux;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('weber');


package Physics::Unit::Mass;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('gram');


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


package Physics::Unit::Pressure;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('pascal');


package Physics::Unit::Resistance;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('ohm');


package Physics::Unit::Speed;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('mps');


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


package Physics::Unit::Time;
use strict;
use Physics::Unit::Scalar;
use vars qw( @ISA $MyUnit );
@ISA = qw( Physics::Unit::Scalar );

$MyUnit = GetUnit('second');


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
