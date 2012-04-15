use Test::More tests => 3;

BEGIN { use_ok('Physics::Unit::Vector') };

$v = new Physics::Unit::Vector('3m', '4m', '5m');
ok(defined $v,   "new Vector");
is(ref $v, 'Physics::Unit::Vector', 'Vector type');
