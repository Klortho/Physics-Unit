BEGIN {
    # '-d' is used to debug the unit expression parser
    if ($ARGV[0] eq '-d') {
        $Physics::Unit::debug = 1;
    }
}

use Physics::Unit ':ALL';


$mile = GetUnit('mile');
$foot = GetUnit('foot');
$c = $mile->convert($foot);     # $c == 5280

print "A mile is $c feet\n";

