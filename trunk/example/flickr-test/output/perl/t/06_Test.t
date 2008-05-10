#
# Test case for WebService::Flickr::Test
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
plan tests => 44;

use_ok('WebService::Flickr::Test');

my $obj = WebService::Flickr::Test->new();

ok(ref $obj, 'new WebService::Flickr::Test()');


# echo / Test[0]
{
    my $params = {
        'api_key' => $ENV{'FLICKR_API_KEY'},
    };
    my $res = eval { $obj->echo(%$params); };
    ok( ! $@, 'echo / Test[0]: die' );
    ok( ! $res->is_error, 'echo / Test[0]: is_error' );
    my $data = $res->root;
    ok( ref $data, 'echo / Test[0]: root' );
    can_ok( $data, 'stat' );
    if ( $data->can('stat') ) {
        ok( $data->stat, 'echo / Test[0]: stat' );
    }
    can_ok( $data, 'method' );
    if ( $data->can('method') ) {
        ok( $data->method, 'echo / Test[0]: method' );
    }
    can_ok( $data, 'api_key' );
    if ( $data->can('api_key') ) {
        ok( $data->api_key, 'echo / Test[0]: api_key' );
    }
}

# echo / Test[1]
{
    my $params = {
        'api_key' => 'invalid_api_key',
    };
    my $res = eval { $obj->echo(%$params); };
    ok( ! $@, 'echo / Test[1]: die' );
    ok( ! $res->is_error, 'echo / Test[1]: is_error' );
    my $data = $res->root;
    ok( ref $data, 'echo / Test[1]: root' );
    can_ok( $data, 'stat' );
    if ( $data->can('stat') ) {
        ok( $data->stat, 'echo / Test[1]: stat' );
    }
    can_ok( $data, 'err' );
    if ( $data->can('err') ) {
        ok( $data->err, 'echo / Test[1]: err' );
    }
    can_ok( $data->err, 'code' );
    if ( $data->err->can('code') ) {
        ok( $data->err->code, 'echo / Test[1]: code' );
    }
    can_ok( $data->err, 'msg' );
    if ( $data->err->can('msg') ) {
        ok( $data->err->msg, 'echo / Test[1]: msg' );
    }
}



# login / Test[0]
{
    my $params = {
        'api_key' => $ENV{'FLICKR_API_KEY'},
        'api_sig' => $ENV{'FLICKR_API_SIG'},
        'auth_token' => $ENV{'FLICKR_AUTH_TOKEN'},
    };
    my $res = eval { $obj->login(%$params); };
    ok( ! $@, 'login / Test[0]: die' );
    ok( ! $res->is_error, 'login / Test[0]: is_error' );
    my $data = $res->root;
    ok( ref $data, 'login / Test[0]: root' );
    can_ok( $data, 'stat' );
    if ( $data->can('stat') ) {
        ok( $data->stat, 'login / Test[0]: stat' );
    }
    can_ok( $data, 'user' );
    if ( $data->can('user') ) {
        ok( $data->user, 'login / Test[0]: user' );
    }
    can_ok( $data->user, 'id' );
    if ( $data->user->can('id') ) {
        ok( $data->user->id, 'login / Test[0]: id' );
    }
    can_ok( $data->user, 'username' );
    if ( $data->user->can('username') ) {
        ok( $data->user->username, 'login / Test[0]: username' );
    }
}

# login / Test[1]
{
    my $params = {
        'api_key' => 'invalid_api_key',
        'api_sig' => 'invalid_api_sig',
        'auth_token' => 'invalid_auth_token',
    };
    my $res = eval { $obj->login(%$params); };
    ok( ! $@, 'login / Test[1]: die' );
    ok( ! $res->is_error, 'login / Test[1]: is_error' );
    my $data = $res->root;
    ok( ref $data, 'login / Test[1]: root' );
    can_ok( $data, 'stat' );
    if ( $data->can('stat') ) {
        ok( $data->stat, 'login / Test[1]: stat' );
    }
    can_ok( $data, 'err' );
    if ( $data->can('err') ) {
        ok( $data->err, 'login / Test[1]: err' );
    }
    can_ok( $data->err, 'code' );
    if ( $data->err->can('code') ) {
        ok( $data->err->code, 'login / Test[1]: code' );
    }
    can_ok( $data->err, 'msg' );
    if ( $data->err->can('msg') ) {
        ok( $data->err->msg, 'login / Test[1]: msg' );
    }
}



1;
