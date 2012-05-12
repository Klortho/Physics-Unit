# This test program contains all the examples from the Physics::Unit
# documentation.

use Physics::Unit ':ALL';   # exports all util. function names

# Define your own unit named "ff"
$ff = new Physics::Unit('furlong / fortnight', 'ff');
print $ff->type, "\n";         # prints:  Speed

# Convert to mph; this prints:  One ff is 0.0003720... miles per hour
print "One ", $ff->name, " is ", $ff->convert('mph'), " miles per hour\n";

# Get canonical string representation
print $ff->expanded, "\n";     # prints:  0.0001663... m s^-1

# More intricate unit expression (using the newly defined unit 'ff'):
$gonzo = new Physics::Unit "13 square millimeters per ff";
print $gonzo->expanded, "\n";  # prints:  0.07816... m s

# Doing arithmetic maintains the types of units
$m = $ff->copy->times("5 kg");
print "This ", $m->type, " unit is ", $m->ToString, "\n";
# prints: This Momentum unit is 0.8315... m gm s^-1




#---------------------

print "One mph is ", GetUnit('mph')->factor, " meters / sec\n";

#---------------------

InitBaseUnit('Beauty' => ['sonja', 'sonjas', 'yh']);

#---------------------

InitPrefix('gonzo' => 1e100, 'piccolo' => 1e-100);

$beauty_rate = new Physics::Unit('5 piccolosonjas / hour');

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


# Create a new copy of a predefined, typed unit:
$u3 = GetUnit('joule')->new;
$t = $u3->type;       # 'Energy'
print "u3->type is $t\n";

# But take care; if you use the C<new()> method with a name, then that's
# considered a unit expression, and the type is not preserved
$u4 = new Physics::Unit('joule');
$t = $u4->type;       # ['Energy', 'Torque']
print "u4->type is $t\n";

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
