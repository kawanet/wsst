use strict;
use Test::More tests => 8;

BEGIN { use_ok("WSST::BuiltinSchemaParser"); }

can_ok("WSST::BuiltinSchemaParser", qw(types parse));

my $obj = WSST::BuiltinSchemaParser->new();
ok(ref $obj, '$obj->new()');
is_deeply($obj->types, ['.yml', '.yaml'], '$obj->types');

my $schema = eval { $obj->parse('t/test_schema.yml'); };
ok($schema, '$obj->parse(t/test_schema.yml)');
ok(!$@, '$obj->parse(t/test_schema.yml)');

$schema = eval { $obj->parse('t/XXXXX.test'); };
ok(!$schema, '$obj->parse(t/XXXXX.test)');
ok($@, '$obj->parse(t/XXXXX.test)');

1;
