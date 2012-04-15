BEGIN {
    # '-d' is used to debug the Scalar module
    if ($ARGV[0] eq '-d') {
        $Physics::Unit::Scalar::debug = 1;
    }
}

use Physics::Unit::Scalar;

$d = new Physics::Unit::Distance('98 mi');
print "98 mi Physics::Unit::Distance is\n";
for (sort keys %$d) {
    print "\t$_ => $$d{$_}\n";
}

