use strict;
use Test::More;

my $FILES = [qw(
    lib/WebService/Flickr/Test.pm
    lib/WebService/Flickr/Test/Base.pm
    lib/WebService/Flickr/Test/Echo.pm
    lib/WebService/Flickr/Test/Login.pm
)];
local $@;
eval "use Test::Pod 1.00";
plan skip_all => "Test::Pod 1.00 required for testing POD" if $@;
all_pod_files_ok( @$FILES );
;1;
