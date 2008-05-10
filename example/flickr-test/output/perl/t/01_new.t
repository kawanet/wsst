#
# Test case for WebService::Flickr::Test
#

use strict;
use Test::More tests => 2;

BEGIN { use_ok('WebService::Flickr::Test'); }

my $obj = new WebService::Flickr::Test();
ok( ref $obj, 'new WebService::Flickr::Test()');

1;
