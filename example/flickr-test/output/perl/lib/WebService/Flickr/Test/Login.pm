package WebService::Flickr::Test::Login;

use strict;
use base qw( WebService::Flickr::Test::Base );
use vars qw( $VERSION );
use Class::Accessor::Fast;
use Class::Accessor::Children::Fast;

$VERSION = '0.0.1';

sub http_method { 'GET'; }

sub url { 'http://api.flickr.com/services/rest/'; }

sub query_class { 'WebService::Flickr::Test::Login::Query'; }

sub query_fields { [
    'api_key', 'api_sig', 'auth_token'
]; }

sub default_param { {
    'method' => 'flickr.test.login'
}; }

sub notnull_param { [
    'method', 'api_key', 'api_sig', 'auth_token'
]; }

sub elem_class { 'WebService::Flickr::Test::Login::Element'; }

sub root_elem { 'rsp'; }

sub elem_fields { {
    'err' => ['code', 'msg'],
    'rsp' => ['stat', 'user', 'stat', 'err'],
    'user' => ['id', 'username'],

}; }

sub force_array { [
    
]; }

# __PACKAGE__->mk_query_accessors();

@WebService::Flickr::Test::Login::Query::ISA = qw( Class::Accessor::Fast );
WebService::Flickr::Test::Login::Query->mk_accessors( @{query_fields()} );

# __PACKAGE__->mk_elem_accessors();

@WebService::Flickr::Test::Login::Element::ISA = qw( Class::Accessor::Children::Fast );
WebService::Flickr::Test::Login::Element->mk_ro_accessors( root_elem() );
WebService::Flickr::Test::Login::Element->mk_child_ro_accessors( %{elem_fields()} );

=head1 NAME

WebService::Flickr::Test::Login - Flickr Services: Test API Methods "login" API

=head1 SYNOPSIS

    use WebService::Flickr::Test;
    
    my $service = WebService::Flickr::Test->new();
    
    my $param = {
        'api_key' => $ENV{'FLICKR_API_KEY'},
        'api_sig' => $ENV{'FLICKR_API_SIG'},
        'auth_token' => $ENV{'FLICKR_AUTH_TOKEN'},
    };
    my $res = $service->login( %$param );
    my $data = $res->root;
    print "stat: $data->stat\n";
    print "user: $data->user\n";
    print "id: $data->user->id\n";
    print "username: $data->user->username\n";
    print "...\n";

=head1 DESCRIPTION

This module is a interface for the C<login> API.
It accepts following query parameters to make an request.

    my $param = {
        'api_key' => 'XXXXXXXX',
        'api_sig' => 'XXXXXXXX',
        'auth_token' => 'XXXXXXXX',
    };
    my $res = $service->login( %$param );

C<$service> above is an instance of L<WebService::Flickr::Test>.

=head1 METHODS

=head2 root

This returns the root element of the response.

    my $root = $res->root;

You can retrieve each element by the following accessors.

    $root->stat
    $root->user
    $root->user->id
    $root->user->username


=head2 xml

This returns the raw response context itself.

    print $res->xml, "\n";

=head2 code

This returns the response status code.

    my $code = $res->code; # usually "200" when succeeded

=head2 is_error

This returns true value when the response has an error.

    die 'error!' if $res->is_error;

=head1 SEE ALSO

L<WebService::Flickr::Test>

=head1 AUTHOR

Yusuke Kawasaki <u-suke [at] kawa.net>

=head1 COPYRIGHT

Copyright 2008 Yusuke Kawasaki

=cut
1;
