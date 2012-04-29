# This test program contains all the examples from the Physics::Unit
# documentation.

use Physics::Unit ':ALL';   # exports all util. function names

# Define your own units
$ss = new Physics::Unit('furlong / fortnight', 'ff');

# Print the expanded representation of a unit
print $ss->expanded, "\n";

# Convert from one to another
print "One ", $ss->name, " is ", $ss->convert('mph'), " miles per hour\n";

# Get a Unit's conversion factor
print "Conversion factor of foot is ", GetUnit('foot')->factor, "\n";

#---------------------

print "One mph is ", GetUnit('mph')->factor, " meters / sec\n";

#---------------------

InitBaseUnit('Beauty' => ['sonja', 'sonjas', 'smw']);

#---------------------

InitPrefix('gonzo' => 1e100, 'piccolo' => 1e-100);

$beauty_rate = new Physics::Unit('5 piccolosonja / hour');

#---------------------

InitUnit( ['chris', 'cfm'] => '3 piccolosonjas' );

#---------------------

InitTypes( 'Aging' => 'chris / year' );

#---------------------

# Create a new, anonymous unit:
$u = new Physics::Unit ('3 pi sonjas per s');

# Create a new, named unit:
$u = new Physics::Unit ('3 pi sonjas per s', 'bloom');

# Create a new unit with a list of names:
$u  = new Physics::Unit ('3 pi sonjas per s', 'b', 'blooms', 'blm');
$n = $u->name;    # returns 'b'

#---------------------

$u1 = new Physics::Unit('kg m^2/s^2');
$t = $u1->type;       #  $t == ['Energy', 'Torque']

$u1->type('Energy');  #  This establishes the type once and for all
$t = $u1->type;       #  $t == 'Energy'


# Now create another Unit object from the same definition
$u2 = new Physics::Unit('kg m^2/s^2');

# This is a brand-new object, so the explicit type is unknown, as before:
$t = $u2->type;    # $t == ['Energy', 'Torque']


# But if we use a predefined, named unit, we get a single type:
$u3 = GetUnit('joule')->new;    # *not*  Physics::Unit->new('joule');
$t = $u3->type;    # $t == 'Energy'

#---------------------

print GetUnit('calorie')->expanded, "\n";

#---------------------

$mile = GetUnit('mile');
$foot = GetUnit('foot');
$c = $mile->convert($foot);     # returns 5280

#---------------------

$u = new Physics::Unit('36 m^2');
$u->divide('3 meters');    # $u is now '12 m'
$u->divide(3);             # $u is now '4 m'
$u->divide( new Physics::Unit('.5 sec') );  # $u is now '8 m/s'

#---------------------

print "ok\n";
