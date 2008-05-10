#
# Test case for WebService::Flickr::Test
#

use strict;
use Test::More tests => 4;


{
    use_ok('WebService::Flickr::Test::Echo');
    my $obj = new WebService::Flickr::Test::Echo();
    ok( ref $obj, 'new WebService::Flickr::Test::Echo()');
}

{
    use_ok('WebService::Flickr::Test::Login');
    my $obj = new WebService::Flickr::Test::Login();
    ok( ref $obj, 'new WebService::Flickr::Test::Login()');
}


1;
