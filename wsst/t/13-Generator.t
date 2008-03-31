use strict;
use Test::More tests => 2;

BEGIN { use_ok("WSST::Generator"); }

can_ok("WSST::Generator", qw(generator_names generate));

1;
