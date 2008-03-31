use strict;
use Test::More tests => 2;

BEGIN { use_ok("WSST::Command"); }

can_ok("WSST::Command", qw(command_names execute));

1;
