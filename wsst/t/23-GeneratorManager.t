use strict;
use Test::More tests => 16;

BEGIN { use_ok("WSST::GeneratorManager"); }

can_ok("WSST::GeneratorManager", qw(get_generator instance init));

$WSST::COMMAND_OPTS = {
    'defs' => {
        'tmpl_dir' => 't/test_templates',
    },
};

WSST::PluginManager->init(plugin_dir => 't/test_plugins');

my $obj = WSST::GeneratorManager->instance;

ok(ref $obj, '$obj->instance');

is(ref $obj->{generators}, "ARRAY", 'type $obj->{generators}');
is(ref $obj->{generator_name_map}, "HASH", 'type $obj->{generator_name_map}');
is(ref $obj->{generator_full_name_map}, "HASH", 'type $obj->{generator_full_name_map}');

is_deeply(scalar(@{$obj->{generators}}), 2, '$obj->{generators}');
is_deeply([sort keys %{$obj->{generator_name_map}}], ['test1', 'test2', 'test_plugin3'], '$obj->{generator_name_map}');
is_deeply([sort keys %{$obj->{generator_full_name_map}}], ['__builtin__.test1', '__builtin__.test2', 'test_plugin3.test_plugin3'], '$obj->{generator_full_name_map}');

ok($obj->get_generator('test1'), '$obj->get_generator(test1)');
ok($obj->get_generator('test2'), '$obj->get_generator(test2)');
ok(!$obj->get_generator('XXXXX'), '$obj->get_generator(XXXXX)');
ok($obj->get_generator('test_plugin3'), '$obj->get_generator(test_plugin3)');

ok($obj->get_generator('__builtin__.test1'), '$obj->get_generator(__builtin__.test1)');
ok(!$obj->get_generator('Hoge.XXXXX'), '$obj->get_generator(Hoge.XXXXX)');
ok($obj->get_generator('test_plugin3.test_plugin3'), '$obj->get_generator(test_plugin3.test_plugin3)');

1;
