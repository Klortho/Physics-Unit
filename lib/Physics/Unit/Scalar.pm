package Physics::Unit::Scalar;

use strict;
use Carp;
use vars qw($VERSION $debug);
$VERSION = '0.04_02';
$VERSION = eval $VERSION;

use Physics::Unit ':ALL';

# This is the actual content of a user defined unit.
my $subclass_template = <<'END_TEMPLATE';
package Physics::Unit::%s;
use strict;
use base qw(Physics::Unit::Scalar);
use Physics::Unit ':ALL';
use vars qw($MyUnit $DefaultUnit);
$MyUnit = GetUnit('%s');
$DefaultUnit = $MyUnit;
1;
END_TEMPLATE

# Call the InitSubtypes() function.
InitSubtypes();

sub new {
    my $proto = shift;
    print "Scalar::new:  proto is $proto.\n" if $debug;
    my $class;
    my $self = {};

    if (ref $proto) {
        # Copy constructor
        $class = ref $proto;
        $self->{$_} = $$proto{$_} for keys %$proto;
    }
    else {
        # Construct from a definition string
        # Get the definition string, and remove whitespace
        my $def = shift;
        print "def is '$def'.\n" if $debug;
        if (defined $def) {
            $def =~ s/^\s*(.*?)\s*$/$1/;
        }

        $class = $proto;

        # Convert the argument into a unit object
        if ($class eq 'Physics::Unit::Scalar') {
            # Build a generic Physics::Unit::Scalar object

            return ScalarFactory($def);

            #my $u = Physics::Unit->new($def);
            #$self->{value} = $u->factor;
            #$u->factor(1);
            #$self->{MyUnit} = $self->{default_unit} = $u;
        }
        else {
            # The user specified the type of Scalar explicitly
            my $mu = $self->{MyUnit} = $self->{default_unit} =
                GetMyUnit($class);

            # If no definition string was given, then set the value to
            # one.

            if (!defined $def || $def eq '') {
                $self->{value} = 1;
            }

            # If the definition consists of just a number, then we'll use
            # the default unit

            elsif ($def =~ /^$Physics::Unit::number_re$/io) {
                $self->{value} = $def + 0;  # convert to number
            }

            else {
                my $u = GetUnit($def);

                croak 'Unit definition string is of incorrect type'
                    if 'Physics::Unit::' . $u->type ne $class;

                $self->{value} = $u->convert($mu);
            }
        }
    }

    bless $self, $class;
}

sub ScalarFactory {
    my $self = {
        value  => 1,
        MyUnit => Physics::Unit->new(shift),
    };

    # Call the mystery ScalarResolve() function.
    return ScalarResolve($self);
}

sub default_unit {
    my $proto = shift;
    if (ref $proto) {
        return $proto->{default_unit};
    }
    else {
        return GetDefaultUnit($proto);
    }
}

sub ToString {
    my $self = shift;
    return $self->value .' '. $self->MyUnit->ToString unless @_;
    my $u = GetUnit(shift);
    my $v = $self->value * $self->MyUnit->convert($u);
    return $v .' '. $u->ToString;
}

sub convert {
    my $self = shift;

    my $u = GetUnit(shift);

    croak 'convert called with invalid parameters'
        if !ref $self || !ref $u;

    return $self->value * $self->MyUnit->convert($u);
}

sub value {
    my $self = shift;
    $self->{value} = shift if @_;
    return $self->{value};
}

sub add {
    my $self = shift;

    my $other = GetScalar(shift);

    croak 'Invalid arguments to Physics::Unit::Scalar::add'
        if !ref $self || !ref $other;
    carp "Scalar types don't match in add()"
        if ref $self ne ref $other;

    $self->{value} += $other->{value};

    return $self;
}

sub neg {
    my $self = shift;
    croak 'Invalid arguments to Physics::Unit::Scalar::neg'
        if !ref $self;

    $self->{value} = - $self->{value};
}

sub subtract {
    my $self = shift;

    my $other = GetScalar(shift);

    croak 'Invalid arguments to Physics::Unit::Scalar::subtract'
        if !(ref $self) || !(ref $other);
    carp "Scalar types don't match in subtract()"
        if ref $self ne ref $other;

    $self->{value} -= $other->{value};

    return $self;
}

sub times {
    my $self = shift;
    my $other = GetScalar(shift);

    croak 'Invalid arguments to Physics::Unit::Scalar::times'
        if !ref $self || !ref $other;

    my $value = $self->{value} * $other->{value};

    my $mu = $self->{MyUnit}->copy;

    $mu->times($other->{MyUnit});

    my $newscalar = {
        value  => $value,
        MyUnit => $mu,
    };

    return ScalarResolve($newscalar);
}

sub recip {
    my $self = shift;
    croak 'Invalid argument to Physics::Unit::Scalar::recip'
        unless ref $self;

    croak 'Attempt to take reciprocal of a zero Scalar'
        unless $self->{value};

    my $mu = $self->{MyUnit}->copy;

    my $newscalar = {
        value  => 1 / $self->{value},
        MyUnit => $mu->recip,
    };

    return ScalarResolve($newscalar);
}

sub div {
    my $self = shift;

    my $other = GetScalar(shift);

    croak 'Invalid arguments to Physics::Unit::Scalar::times'
        if !ref $self || !ref $other;

    my $arg = $other->recip;

    return $self->times($arg);
}

sub GetScalar {
    my $n = shift;
    if (ref $n) {
        return $n;
    }
    else {
        return ScalarFactory($n);
    }
}

sub InitSubtypes {

    for my $type (ListTypes()) {
        print "Creating class $type\n" if $debug;

        my $prototype = GetTypeUnit($type);

        my $type_unit_name = $prototype->name || $prototype->def;

        {
            no strict 'refs';
            no warnings 'once';
            my $package = 'Physics::Unit::' . $type;
            @{$package . '::ISA'} = qw(Physics::Unit::Scalar);
            ${$package . '::DefaultUnit'} = ${$package . '::MyUnit'} = GetUnit( $type_unit_name );
        }

    }

}

sub MyUnit {
    my $proto = shift;
    if (ref ($proto)) {
        return $proto->{MyUnit};
    }
    else {
        return GetMyUnit($proto);
    }
}

sub GetMyUnit {
    my $class = shift;
    no strict 'refs';
    return ${$class . '::MyUnit'};
}

sub GetDefaultUnit {
    my $class = shift;
    no strict 'refs';
    return ${$class . '::DefaultUnit'};
}

sub ScalarResolve {
    my $self = shift;

    my $mu = $self->{MyUnit};

    my $type = $mu->type;

    if ($type) {
        $type = 'dimensionless' if $type eq 'prefix';
        $type = 'Physics::Unit::' . $type;

        my $newunit = GetMyUnit($type);

        $self->{value} *= $mu->convert($newunit);

        $self->{MyUnit} = $newunit;

        $self->{default_unit} = $newunit;
    }
    else {
        $type = "Physics::Unit::Scalar";

        $self->{value} *= $mu->factor;

        $mu->factor(1);

        $self->{default_unit} = $mu;
    }

    bless $self, $type;
}

1;

