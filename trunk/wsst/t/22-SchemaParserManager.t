use strict;
use Test::More tests => 9;

BEGIN { use_ok("WSST::SchemaParserManager"); }

can_ok("WSST::SchemaParserManager", qw(get_schema_parser instance init));

WSST::PluginManager->init(plugin_dir => 't/test_plugins');

my $obj = WSST::SchemaParserManager->instance;

ok(ref $obj, '$obj->instance');

is(ref $obj->{parsers}, "ARRAY", 'type $obj->{parsers}');
is(ref $obj->{parser_type_map}, "HASH", 'type $obj->{parser_type_map}');

my $parser = eval { $obj->get_schema_parser('t/test_schema.yml'); };
ok($parser, '$obj->get_schema_parser(t/test_schema.yml)');
ok(!$@, '$obj->get_schema_parser(t/test_schema.yml)');

$parser = eval { $obj->get_schema_parser('t/XXXXX.test'); };
ok(!$parser, '$obj->get_schema_parser(t/XXXXX.test)');
ok($@, '$obj->get_schema_parser(t/XXXXX.test)');

1;
