use strict;
use Test::More tests => 9;

BEGIN { use_ok('WSST::PluginManager'); }

can_ok('WSST::PluginManager', qw(get_plugin load_plugin find_plugins instance init));

WSST::PluginManager->init(plugin_dir => 't/test_plugins');

my $obj = WSST::PluginManager->instance;

ok(ref $obj, '$obj->instance');

is(ref \$obj->{plugin_dir}, 'SCALAR', 'type $obj->{plugin_dir}');
is(ref $obj->{plugins}, 'ARRAY', 'type $obj->{plugins}');
is(ref $obj->{plugin_name_map}, 'HASH', 'type $obj->{plugin_name_map}');

is($obj->{plugin_dir}, 't/test_plugins', '$obj->{plugin_dir}');
is_deeply([map {$_->name} @{$obj->{plugins}}], [qw(WSST::Plugin::TestPlugin test_plugin2 test_plugin3)], '$obj->{plugins}');
is_deeply([sort keys %{$obj->{plugin_name_map}}], [qw(WSST::Plugin::TestPlugin test_plugin2 test_plugin3)], '$obj->{plugin_name_map}');

1;
