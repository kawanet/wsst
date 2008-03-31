use strict;
use Test::More tests => 15;

BEGIN { use_ok("WSST::CommandManager"); }

can_ok("WSST::CommandManager", qw(get_command instance));

WSST::PluginManager->init(plugin_dir => 't/test_plugins');

my $obj = WSST::CommandManager->instance;

ok(ref $obj, 'WSST::CommandManager->get_instance()');

is(ref $obj->{commands}, "ARRAY", 'type $obj->{commands}');
is(ref $obj->{command_name_map}, "HASH", 'type $obj->{command_name_map}');
is(ref $obj->{command_full_name_map}, "HASH", 'type $obj->{command_full_name_map}');

is_deeply(scalar(@{$obj->{commands}}), 1, '$obj->{commads}');
is_deeply([sort keys %{$obj->{command_name_map}}], [qw(dumpschema generate help listlangs listplugins version)], '$obj->{command_name_map}');
is_deeply([sort keys %{$obj->{command_full_name_map}}], [qw(__builtin__.dumpschema __builtin__.generate __builtin__.help __builtin__.listlangs __builtin__.listplugins __builtin__.version)], '$obj->{command_full_name_map}');

ok($obj->get_command('help'), '$obj->get_command(help)');
ok($obj->get_command('listplugins'), '$obj->get_command(listplugins)');
ok($obj->get_command('generate'), '$obj->get_command(generate)');

ok($obj->get_command('__builtin__.help'), '$obj->get_command(__builtin__.help)');
ok($obj->get_command('__builtin__.listplugins'), '$obj->get_command(__builtin__.listplugins)');
ok($obj->get_command('__builtin__.generate'), '$obj->get_command(__builtin__.generate)');

1;
