#
# Test case for WebService::Flickr::Test::Echo
#

use strict;
use Test::More;

{
    my $errs = [];
    foreach my $key ('FLICKR_API_KEY') {
        next if exists $ENV{$key};
        push(@$errs, $key);
    }
    plan skip_all => sprintf('set %s env to test this', join(", ", @$errs))
        if @$errs;
}
plan tests => 22;

use_ok('WebService::Flickr::Test::Echo');

my $service = new WebService::Flickr::Test::Echo();

ok( ref $service, 'new WebService::Flickr::Test::Echo()' );


# Test[0]
{
    my $params = {
        'api_key' => $ENV{'FLICKR_API_KEY'},
    };
    my $res = new WebService::Flickr::Test::Echo();
    $res->add_param(%$params);
    eval { $res->request(); };
    ok( ! $@, 'Test[0]: die' );
    ok( ! $res->is_error, 'Test[0]: is_error' );
    my $data = $res->root;
    ok( ref $data, 'Test[0]: root' );
    can_ok( $data, 'stat' );
    ok( eval { $data->stat }, 'Test[0]: stat' );
    can_ok( $data, 'method' );
    ok( eval { $data->method }, 'Test[0]: method' );
    can_ok( $data, 'api_key' );
    ok( eval { $data->api_key }, 'Test[0]: api_key' );
}

# Test[1]
{
    my $params = {
        'api_key' => 'invalid_api_key',
    };
    my $res = new WebService::Flickr::Test::Echo();
    $res->add_param(%$params);
    eval { $res->request(); };
    ok( ! $@, 'Test[1]: die' );
    ok( ! $res->is_error, 'Test[1]: is_error' );
    my $data = $res->root;
    ok( ref $data, 'Test[1]: root' );
    can_ok( $data, 'stat' );
    ok( eval { $data->stat }, 'Test[1]: stat' );
    can_ok( $data, 'err' );
    ok( eval { $data->err }, 'Test[1]: err' );
    can_ok( $data->err, 'code' );
    ok( eval { $data->err->code }, 'Test[1]: code' );
    can_ok( $data->err, 'msg' );
    ok( eval { $data->err->msg }, 'Test[1]: msg' );
}


1;
