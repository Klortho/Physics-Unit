package Physics::Unit::Vector;

use strict;
use Carp;
use vars qw($VERSION $debug);
$VERSION = '0.04';
use Physics::Unit::Scalar;


my %vec_type = (
    'Physics::Unit::Distance' => 'Displacement',
);

# Scalar         Vector subtype
# ---------------------------------
# Acceleration   AccelerationVec
# Area           AreaVec
# Current        CurrentVec
# Distance       Displacement
# Force          ForceVec
# Magnetic-field Magnetic-field-Vec
# Magnetic-flux  Magnetic-flux-Vec
# Power          PowerVec
# Pressure       PressureVec
# Speed          Velocity

sub new {
    my $proto = shift;
    my $self  = {};
    my $class;

    if ($class = ref $proto) {
        # copy constructor
        for (keys %$proto) {
            # XXX This is not done: I also need to *copy* those data
            # XXX members that are references.
            $self->{$_} = $$proto{$_};
        }
    }
    else {
        $class = $proto;

        # The first argument will tell us what type of vector this is
        my $s = shift;
        print "first argument is $s.\n" if $debug;

        if (!ref($s))
        {
            $s = Physics::Unit::Scalar->new($s);
        }
        print "which converts to the argument $s.\n" if $debug;

        my @scalar;
        push @scalar, $s;

        my $stype = ref($s);
        my $class = $vec_type{$stype};
        if (!$class)
        {
            croak "Can't make a vector out of $stype 's!";
        }

        # Now do the next two arguments
        foreach $s (@_)
        {
            my $s2 = $s;
            if (!ref($s2))
            {
                $s2 = Physics::Unit::Scalar->new($s2);
            }
            my $this_stype = ref($s2);
            if ($this_stype ne $stype)
            {
                croak "Can't create inhomogenous vectors!";
            }
            push @scalar, $s2;
        }

        # Now normalize
        my $mag = ($scalar[0]->value ** 2 +
                   $scalar[1]->value ** 2 +
                   $scalar[2]->value ** 2) ** 0.5;
        $self->{magnitude} = $mag;
        $self->{direction} = [ map $_ / $mag, @scalar ];

    }

    bless $self, $class;
}

1;
__END__

=head1 NAME

Physics::Unit::Vector

=head1 DESCRIPTION

Objects of this class hold a physical vector.

This class has several subtypes, which depend on the dimensionality
of the scalar used to hold the magnitude.

=head1 new()

  $v = new Physics::Unit::Vector('3m', '4m', '5mi');

given Scalars of the same type, $sx, $sy, and $sz:

  $v = new Physics::Unit::Vector($sx, $sy, $sz);

=head1 AUTHOR

Chris Maloney <Dude@chrismaloney.com>

=head1 COPYRIGHT AND LICENSE

Copyright 2002-2003 by Chris Maloney

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
