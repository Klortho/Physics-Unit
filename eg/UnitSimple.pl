use Physics::Unit ':ALL';


$mile = GetUnit('mile');
$foot = GetUnit('foot');
$c = $mile->convert($foot);     # $c == 5280

print "A mile is $c feet\n";

