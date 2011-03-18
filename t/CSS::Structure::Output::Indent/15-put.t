# Modules.
use CSS::Structure::Output::Indent;
use Test::More 'tests' => 1;

# Debug message.
print "Testing: put() method.\n";

# Test.
$obj = CSS::Structure::Output::Indent->new(
	'skip_bad_types' => 1,
);
$obj->put(
	['x', 'bad selector'],
);
$ret = $obj->flush;
is($ret, '');
