# Modules.
use English qw(-no_match_vars);
use File::Object;
use Test::More 'tests' => 1;

eval 'use Test::Pod 1.00';
if ($EVAL_ERROR) {
	plan skip_all => 'Test::Pod 1.00 required for testing POD';
}
pod_file_ok(File::Object->new->up(2)->file_path('Structure/Output/Core.pm')
	->serialize);