#
# Test case for WebService::Flickr::Test::Login
#

use strict;
use Test::More;

{
    my $errs = [];
    foreach my $key ('FLICKR_API_KEY', 'FLICKR_API_SIG', 'FLICKR_AUTH_TOKEN') {
        next if exists $ENV{$key};
        push(@$errs, $key);
    }
    plan skip_all => sprintf('set %s env to test this', join(", ", @$errs))
        if @$errs;
}
plan tests => 24;

use_ok('WebService::Flickr::Test::Login');

my $service = new WebService::Flickr::Test::Login();

ok( ref $service, 'new WebService::Flickr::Test::Login()' );


# Test[0]
{
    my $params = {
        'api_key' => $ENV{'FLICKR_API_KEY'},
        'api_sig' => $ENV{'FLICKR_API_SIG'},
        'auth_token' => $ENV{'FLICKR_AUTH_TOKEN'},
    };
    my $res = new WebService::Flickr::Test::Login();
    $res->add_param(%$params);
    eval { $res->request(); };
    ok( ! $@, 'Test[0]: die' );
    ok( ! $res->is_error, 'Test[0]: is_error' );
    my $data = $res->root;
    ok( ref $data, 'Test[0]: root' );
    can_ok( $data, 'stat' );
    ok( eval { $data->stat }, 'Test[0]: stat' );
    can_ok( $data, 'user' );
    ok( eval { $data->user }, 'Test[0]: user' );
    can_ok( $data->user, 'id' );
    ok( eval { $data->user->id }, 'Test[0]: id' );
    can_ok( $data->user, 'username' );
    ok( eval { $data->user->username }, 'Test[0]: username' );
}

# Test[1]
{
    my $params = {
        'api_key' => 'invalid_api_key',
        'api_sig' => 'invalid_api_sig',
        'auth_token' => 'invalid_auth_token',
    };
    my $res = new WebService::Flickr::Test::Login();
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
