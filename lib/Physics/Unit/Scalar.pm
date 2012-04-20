package Physics::Unit::Scalar;

use strict;
use Carp;
use vars qw($VERSION $debug);
$VERSION = '0.04_01';
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
    my $file = 'ScalarSubtypes.pm';

    open OUTFILE, ">$file" or croak "Can't write to $file - $!\n"
         if $debug;

    for my $type (ListTypes()) {
        print "Creating class $type\n" if $debug;

        my $prototype = GetTypeUnit($type);

        my $type_unit_name = $prototype->name || $prototype->def;

        my $s = sprintf $subclass_template, $type, $type_unit_name;
        eval $s;
        croak "Error creating class $type" if $@;

        print OUTFILE $s if ($debug);
    }

    close OUTFILE if $debug;
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
__END__

=head1 NAME

Physics::Unit::Scalar

=head1 DESCRIPTION

This package encapsulates information about physical quantities.
Each instance of a class that derives from Physics::Unit::Scalar
holds the value of some type of measurable quantity.  When you use
this module, several new classes are immediately available.  See the
Derived Classes section below for a complete list.

You will probably only need to use these classes that derive from
Physics::Unit::Scalar, such as Physics::Unit::Distance,
Physics::Unit::Speed, etc.  Of course, you are also free to define
your own derived classes, based on types of physical quantities.

This module relies heavily on the Physics::Unit module.  Each Scalar
object has a Unit object that defines the dimensionality of the
Scalar. The dimensionality also defines (more or less) the type of
physical quantity that is stored.  The type of physical quantity
(that is, the type of the Unit object) corresponds to the derived
class to which the object belongs.

For example, the class Physics::Unit::Distance uses the Physics::Unit
object named 'meter' to define the scale of its object instances.
Coincidentally (not really) the type of the Unit object is 'Distance'.

Defining classes that correspond to physical quantity types allows us
to overload the arithmetic methods to produce derived classes of the
correct type automagically.  For example:

  $d = new Physics::Unit::Distance('98 mi');
  $t = new Physics::Unit::Time('36 years');

  # Compute a Speed = Distance / Time
  # $speed will be of type Physics::Unit::Speed.

  my $speed = $d->div($t);

In general, when a new Physics::Unit::Scalar needs to be created as
the result of some operation, this package attempts to determine its
subclass based on its dimensionality.  Thus, when you multiply two
Distances together, the result is an Area object.  This behavior can
be selectively overridden when necessary.

The class was designed this way in order to minimize the programmer's
need to keep track of the various physical types of the objects in
use, and to enable the compiler, in many cases, to verify
computations on the basis of dimensional analysis.  Yet, there needs
to be mechanisms to overide the default behavior in many cases.  For
example, both energy and torque have the same dimensions:
Force * Distance.  Therefore, it remains the programmer's
responsibility, in this case, to assign the correct subclass to
Scalars that have this dimensionality.

=head1 SYNOPSIS

    use Physics::Unit::Scalar;

    # Manipulate Distances
    $d = new Physics::Unit::Distance('98 mi');
    print $d->ToString, "\n";             # prints '157715.712 meter'

    $d->add('10 km');
    print "Sum is ", $d->ToString, "\n";  # prints '167715.712 meter'

    print $d->value, ' ', $d->default_unit->name, "\n";   # same thing

    # Print out a quantity in a different unit:
    print $d->ToString('mile');

    print $d->convert('mile'), " mile\n";    # same thing

    $d2 = new Physics::Unit::Distance('2000');     # no unit given, use the default
    print $d2->ToString, "\n";

    # Manipulate Times
    $t = Physics::Unit::Time->new('36 years');
    print $t->ToString, "\n";              # prints '1136073600 second'

    # Speed equals Distance / Time
    $s = $d->div($t);       #  $s is a Physics::Unit::Speed object
    print $s->ToString, "\n";              # prints ''

    # Create a Scalar with an unknown type
    $s = new Physics::Unit::Scalar('kg m s');
    $f = $s->div('3000 s^3');   # $f is a Physics::Unit::Force

=head1 DEBUG OPTION

Before the use statement, include a line turning debugging on, as in:

    BEGIN { $Physics::Unit::Scalar::debug = 1; }
    use Physics::Unit::Scalar;

This will cause copious debugging output to be generated.  It will
also cause the creation of a file, Scalar_subtypes.pm, which defines
all of the subclasses of Scalar, based on the Unit types.  The text
of this file is evaled in order to define the subclasses.


=head1 UNITS ASSOCIATED WITH SCALARS

Classes and objects derived from Physics::Unit::Scalar follow these
rules:

* All objects of a particular class that derives from
  Physics::Unit::Scalar use the same Physics::Unit object, and thus
  have the same dimensionality and scale.

* Objects of the Physics::Unit::Scalar class (and not a derived class)
  each have their own Physics::Unit object to describe the quantity.

Thus, for example, all objects of type Physics::Unit::Distance use
the Unit object "1 meter".  Objects of type
Physics::Unit::Acceleration use the Unit object "1 meter / sec^2".

Objects of type Physics::Unit::Scalar (and not a derived class) can
use any Unit whatsoever, for example, "1 furlong". There could also
exist an object of type Physics::Unit::Scalar using the Unit "1
meter", but that does not imply that it is a Physics::Unit::Distance
object. The distinction is important when considering the methods
that can be used to manipulate and combine different Scalar types.


=head1 PUBLIC FUNCTIONS

=head2 ScalarFactory($type)

Creates a new object of one of the subtypes of Scalar, from a
definition string (format is the same as that used by the
Physics::Unit module).

The class of the resultant object is the same as the type of the
unit created.

If the type is undef, then the class of the resultant object
will be 'Physics::Unit::Scalar'.

If the type is 'unknown', then this function will throw an
exception (die).

=head2 GetScalar($arg)

This function is used by many of the arithmetic function methods,
wherever an argument specifies a Scalar.  Those arguments can be
passed either as an actual Physics::Unit::Scalar object or as a
string.

This function returns a blessed Physics::Unit::Scalar object.


=head1 PUBLIC METHODS

=head2 new()

Class or object method.  This makes a new user defined unit.
For example:

    # This creates an object of a derived class
    $d = new Physics::Unit::Distance('3 miles');

    # This does the same thing; the type is figured out automagically
    # $d will be a Physics::Unit::Distance
    $d = new Physics::Unit::Scalar('3 miles');

    # Use the default unit for the subtype (for Distance, it's meters):
    $d = new Physics::Unit::Distance(10);

    # This defaults to one meter:
    $d = new Physics::Unit::Distance;

    # Copy constructor:
    $d2 = $d->new;

This method allows you to create new Scalar objects in a number of
ways.

If the type cannot be identified by the dimensionality of the unit,
then a Physics::Unit::Scalar object is returned.  For example:

    $s = new Physics::Unit::Scalar('kg m s');


=head2 ToString()

    $s = $scalar->ToString([unit]);

Prints out the scalar either in the default units or the unit
specified.


=head2 default_unit()

Get the default unit object which is used when printing out
the given Scalar.


=head2 convert()

    $v = $scalar->convert(unit);


=head2 value()

Get or set the value.


=head2 add()

Add another Scalar to the provided one.

=head2 neg()

Take the negative of the Scalar

=head2 subtract()

Subtract another Scalar from this one

=head2 times()

This returns a new Scalar object which is the product of $self and the
scalar argument: i.e.:

    $newscalar = $self * $other

Neither the original object nor the argument is changed.

=head2 recip()

Returns a new Scalar object which is the reciprocal of the object.
The original object is unchanged.

The original object is unchanged.

=head2 div()

This returns a new Scalar object which is a quotient, i.e.

    $newscalar = $self / $other

Neither the original object nor the argument is changed.



=head1 AUTHOR

Chris Maloney <Dude@chrismaloney.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2002-2003 by Chris Maloney

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
