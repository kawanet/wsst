use strict;
use Test::More tests => 40;

BEGIN { use_ok("WSST::Plugin"); }

can_ok('WSST::Plugin', qw(new name));

my $obj1 = WSST::Plugin->new();
ok(ref $obj1, '$obj1->new()');
is($obj1->{init_file}, 't/15-Plugin.t', '$obj1->{init_file}');
is($obj1->{base_dir}, 't', '$obj1->{base_dir}');
is($obj1->name, 'WSST::Plugin', '$obj1->name');

my $obj2 = WSST::Plugin->new(init_file=>'dir/test.pm');
ok(ref $obj2, '$obj2->new(...)');
is($obj2->{init_file}, 'dir/test.pm', '$obj2->{init_file}');
is($obj2->{base_dir}, 'dir', '$obj2->{base_dir}');
is($obj2->name, 'WSST::Plugin', '$obj2->name');

my $obj3 = MyPlugin->new();
ok(ref $obj3, '$obj3->new()');
is($obj3->{init_file}, 't/15-Plugin.t', '$obj3->{init_file}');
is($obj3->{base_dir}, 't', '$obj3->{base_dir}');
is($obj3->name, 'MyPlugin', '$obj3->name');

my $obj4 = MyPlugin->new(init_file=>'dir/test.pm');
ok(ref $obj4, '$obj4->new(...)');
is($obj4->{init_file}, 'dir/test.pm', '$obj4->{init_file}');
is($obj4->{base_dir}, 'dir', '$obj4->{base_dir}');
is($obj4->name, 'MyPlugin', '$obj4->name');

my $obj5 = MyPlugin2->new();
ok(ref $obj5, '$obj5->new()');
is($obj5->{init_file}, 't/15-Plugin.t', '$obj5->{init_file}');
is($obj5->{base_dir}, 't', '$obj5->{base_dir}');
is($obj5->name, 'my_plugin', '$obj5->name');

my $obj6 = MyPlugin2->new(init_file=>'dir/test.pm');
ok(ref $obj6, '$obj6->new(...)');
is($obj6->{init_file}, 'dir/test.pm', '$obj6->{init_file}');
is($obj6->{base_dir}, 'dir', '$obj6->{base_dir}');
is($obj6->name, 'my_plugin', '$obj6->name');

require_ok('t/test_plugins/00-test_plugin.pm');
my $obj7 = WSST::Plugin::TestPlugin->new();
ok(ref $obj7, '$obj7->new()');
isnt($obj7->{init_file}, 't/test_plugins/00-test_plugin.pm', '$obj7->{init_file}');
isnt($obj7->{base_dir}, 't/test_plugins', '$obj7->{base_dir}');
is($obj7->name, 'WSST::Plugin::TestPlugin', '$obj7->name');

my $obj8 = WSST::Plugin::TestPlugin->new(init_file=>'t/test_plugins/00-test_plugin.pm');
ok(ref $obj8, '$obj8->new()');
is($obj8->{init_file}, 't/test_plugins/00-test_plugin.pm', '$obj8->{init_file}');
is($obj8->{base_dir}, 't/test_plugins', '$obj8->{base_dir}');
is($obj8->name, 'WSST::Plugin::TestPlugin', '$obj8->name');

require_ok('t/test_plugins/01-test_plugin2/init.pm');
my $obj9 = WSST::Plugin::TestPlugin2->new();
ok(ref $obj9, '$obj9->new()');
isnt($obj9->{init_file}, 't/test_plugins/01-test_plugin2/init.pm', '$obj9->{init_file}');
isnt($obj9->{base_dir}, 't/test_plugins/01-test_plugin2', '$obj9->{base_dir}');
is($obj9->name, 'test_plugin2', '$obj9->name');

package MyPlugin;

use strict;
use base 'WSST::Plugin';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    return $self;
}

package MyPlugin2;

use strict;
use base 'WSST::Plugin';

sub name {
    return 'my_plugin';
}

1;
