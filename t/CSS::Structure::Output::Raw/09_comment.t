# Modules.
use CSS::Structure::Output::Raw;
use Test::More 'tests' => 13;

print "Testing: Without comment.\n";
my $obj = CSS::Structure::Output::Raw->new(
	'skip_comments' => 1,
);
$obj->put(
	['c', 'comment'],
);
my $ret = $obj->flush;
is($ret, '');

$obj->reset;
$obj->put(
	['c', 'comment'],
	['s', 'body'],
	['e'],
);
$ret = $obj->flush;
is($ret, 'body{}');

$obj->reset;
$obj->put(
	['s', 'body'],
	['c', 'comment1'],
	['c', 'comment2'],
	['e'],
);
$ret = $obj->flush;
is($ret, 'body{}');

$obj->reset;
$obj->put(
	['s', 'body'],
	['d', 'attr1', 'value1'],
	['c', 'comment'],
	['d', 'attr2', 'value2'],
	['e'],
);
$ret = $obj->flush;
is($ret, 'body{attr1:value1;attr2:value2;}');

$obj->reset;
$obj->put(
	['c', 'comment1'],
	['s', 'body'],
	['c', 'comment2'],
	['s', 'div'],
	['e'],
);
$ret = $obj->flush;
is($ret, 'body,div{}');

$obj->reset;
$obj->put(
	['c', 'comment1'],
	['s', 'body'],
	['e'],
	['c', 'comment2'],
	['s', 'div'],
	['e'],
);
$ret = $obj->flush;
is($ret, 'body{}div{}');

print "Testing: Comment.\n";
$obj = CSS::Structure::Output::Raw->new(
	'skip_comments' => 0,
);
$obj->put(
	['c', 'comment'],
);
$ret = $obj->flush;
is($ret, '/*comment*/');

$obj->reset;
$obj->put(
	['c', 'comment'],
	['s', 'body'],
	['e'],
);
$ret = $obj->flush;
is($ret, '/*comment*/body{}');

$obj->reset;
$obj->put(
	['c', 'comment1'],
	['s', 'body'],
	['e'],
	['c', 'comment2'],
	['s', 'div'],
	['e'],
);
$ret = $obj->flush;
is($ret, '/*comment1*/body{}/*comment2*/div{}');

$obj->reset;
$obj->put(
	['s', 'body'],
	['c', 'comment'],
	['e'],
);
$ret = $obj->flush;
is($ret, 'body{/*comment*/}');

$obj->reset;
$obj->put(
	['s', 'body'],
	['c', 'comment1'],
	['c', 'comment2'],
	['e'],
);
$ret = $obj->flush;
is($ret, 'body{/*comment1*//*comment2*/}');

$obj->reset;
$obj->put(
	['s', 'body'],
	['d', 'attr1', 'value1'],
	['c', 'comment'],
	['d', 'attr2', 'value2'],
	['e'],
);
$ret = $obj->flush;
is($ret, 'body{attr1:value1;/*comment*/attr2:value2;}');

$obj->reset;
$obj->put(
	['c', 'comment1'],
	['s', 'body'],
	['c', 'comment2'],
	['s', 'div'],
	['e'],
);
$ret = $obj->flush;
is($ret, '/*comment1*/body,/*comment2*/div{}');
