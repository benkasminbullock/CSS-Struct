# Tests directory.
my $test_main_dir = "$ENV{'PWD'}/t";

# Modules.
use CSS::Structure::Output::Raw;
use Test::More 'tests' => 2;

# Include helpers.
do $test_main_dir.'/get_stdout.inc';

print "Testing: Output handler.\n";
my $obj = CSS::Structure::Output::Raw->new(
	'output_handler' => \*STDOUT,
);
my $ret = get_stdout(
	$obj, 1, 
	['s', 'selector'],
	['d', 'attr', 'value'],
	['e'],
);
is($ret, 'selector{attr:value;}');

$obj = CSS::Structure::Output::Raw->new(
	'auto_flush' => 1,
	'output_handler' => \*STDOUT,
);
$ret = get_stdout(
	$obj, 1, 
	['s', 'selector'],
	['d', 'attr', 'value'],
	['e'],
);
is($ret, 'selector{attr:value;}');
