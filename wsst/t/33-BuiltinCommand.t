use strict;
use Test::More tests => 2;

BEGIN { use_ok("WSST::BuiltinCommand"); }

can_ok("WSST::BuiltinCommand", qw(cmd_generate cmd_help cmd_listplugins cmd_dumpschema cmd_version));

1;
