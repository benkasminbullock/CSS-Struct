# Modules.
use CSS::Structure::Output::Raw;
use English qw(-no_match_vars);
use Test::More 'tests' => 4;

print "Testing: new() plain constructor.\n";
my $obj = CSS::Structure::Output::Raw->new;
ok(defined $obj);
ok($obj->isa('CSS::Structure::Output::Raw'));

print "Testing: new() empty constructor.\n";
eval {
	$obj = CSS::Structure::Output::Raw->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

print "Testing: new('output_handler' = '') bad constructor.\n";
eval {
	$obj = CSS::Structure::Output::Raw->new(
		'output_handler' => '',
	);
};
is($EVAL_ERROR, 'Output handler is bad file handler.'."\n");
