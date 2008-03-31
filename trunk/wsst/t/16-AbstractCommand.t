use strict;
use Test::More tests => 16;

BEGIN { use_ok("WSST::AbstractCommand"); }

can_ok("WSST::AbstractCommand", qw(command_names execute command_method_prefix));

my $obj1 = TestCommand->new();
ok(ref $obj1, '$obj1->new()');
is($obj1->command_method_prefix, 'cmd_', '$obj1->command_method_prefix');
is_deeply($obj1->command_names, ['test'], '$obj1->command_names');

my $ret = eval { $obj1->execute('test'); };
is($ret, 100, '$obj1->execute(test)');
ok(!$@, '$obj1->execute(test)');

$ret = eval { $obj1->execute('XXXXX'); };
ok(!$ret, '$obj1->execute(XXXXX)');
ok($@, '$obj1->execute(XXXXX)');

my $obj2 = TestCommand2->new();
ok(ref $obj2, '$obj2->new()');
is($obj2->command_method_prefix, 'test_cmd_', '$obj2->command_method_prefix');
is_deeply($obj2->command_names, ['test2'], '$obj2->command_names');

$ret = eval { $obj2->execute('test2'); };
is($ret, 1000, '$obj2->execute(test2)');
ok(!$@, '$obj2->execute(test)');

$ret = eval { $obj2->execute('XXXXX'); };
ok(!$ret, '$obj2->execute(XXXXX)');
ok($@, '$obj2->execute(XXXXX)');

package TestCommand;

use strict;
use base qw(WSST::AbstractCommand);

sub cmd_test {
    return 100;
}

package TestCommand2;

use strict;
use base qw(WSST::AbstractCommand);

sub cmd_test {
    return 100;
}

sub test_cmd_test2 {
    return 1000;
}

sub command_method_prefix {
    return "test_cmd_";
}

1;
