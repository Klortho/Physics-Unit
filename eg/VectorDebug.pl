BEGIN {
    # '-d' is used to debug the Vector module
    if ($ARGV[0] eq '-d') {
        $Physics::Unit::Vector::debug = 1;
    }
}

use Physics::Unit::Vector;

$v = new Physics::Unit::Vector('3m', '4m', '5m');
