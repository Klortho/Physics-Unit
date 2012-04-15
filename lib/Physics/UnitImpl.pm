=head1 Physics::Unit Implementation

This page discusses implementation issues of the Physics/Unit.pm
module.

=head1 Data Structures

Four hashes hold all the names known to the package.
There are four types of 'names':
  reserved words - stored in %reserved_word
  unit names - (e.g. 'meter')  All unit names are stored in %unit_by_name
  prefixes - (e.g. 'kilo')  These are special case unit names that can
               be attached to other units with no intervening spaces.
               These are stored in %prefix.
  type names - (e.g. 'distance')  All type names are stored in %prototype.



=head1 Initialization

InitBaseUnit is called to inform the library how many independent
dimensional quantities there are, and what the 'base' unit is for
each quantity.
The library is initialized to know about nine quantities.  More can
be added at run-time, if desired.

InitPrefix is called to initialize the prefixes.
Prefixes are just like dimensionless units, but they don't need to
be separated from the next unit by a space.
Prefix units can only have one name.

Next, InitUnit is called to define units in terms of other units.
Note:  no forward references are allowed here.





=head1 Private Implementation Routines

These are not part of the user-interface.  These are only for use
within the package.

=head2 NewOne()

Creates a new dimensionless unit.

=head2 AddNames()

This is called during the object's construction to add a list of
names to the 'names' array, and to set the reference in the
%unit_by_names cross-reference hash.

=head2 NewType()

   $u->NewType('type');

This is called when we are adding a new type to the system.  This
happens both in InitBaseUnits() and in InitTypes().

=head2 CreateUnit()

This is used by several of the interface utility functions to create
a new unit object from a unit definition (either a simple name, a
unit expression, or a unit object).

It differs from GetUnit in that it always creates a new, anonymous
unit, whereas GetUnit, if given a simple name, returns a reference
to a named unit.

=head2 CompareDim()

Compare the dimension arrays.
Return 0 if they are the same.

=head2 LookName()

Look up the name.  Returns:

  0 not defined
  1 reserved word
  2 unit name
  3 type name

=head2 DebugString()

Convert the unit to a factor - dimension vector format string, e.g.
the unit '3 meters' would be converted to something like

  3 [1, 0, 0]

=head2 CheckChange()

Complain if this unit has a name.  This is used by all the methods
that modify the value of the unit.


=head1 The Parser

Below are listed the private parser functions.
See also the grammar description in the Unit.pm documentation.

=head2 expr()

  expr : term
       | term '/' expr
       | term '*' expr
       | term 'per' expr

=head2 term()

  term : factor
       | term factor

A term is any number of factors separated (nominally) by whitespace.
Whitespace is an 'operator' that means the same thing as multiplication,
but has a higher priority than either '*', '/', or 'per'.

Examples of terms (the following lines each contain one term):

  3pi radians
  3e+4 globules


=head2 Factor()

  factor : prim
         | prim '**' integer

Note that a primary can be an integer, of course, so factors can
look like this:

  meter ** 3 ^ 5    # note, '**' and '^' are synonymous


=head2 prim()

  prim : number
       | word
       | '(' expr ')'
       | 'square' primary
       | 'sq' primary
       | 'cubic' primary
       | primary 'squared'
       | primary 'cubed'

The unary operators square, sq, cubic, squared, and cubed are
implemented as part of this function.  Thus they have quite a
high precedence, as I think they should.


=head2 get_token()

Only used by new above to parse the unit definition string.

