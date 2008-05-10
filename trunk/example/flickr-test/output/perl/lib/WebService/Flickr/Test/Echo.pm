package WebService::Flickr::Test::Echo;

use strict;
use base qw( WebService::Flickr::Test::Base );
use vars qw( $VERSION );
use Class::Accessor::Fast;
use Class::Accessor::Children::Fast;

$VERSION = '0.0.1';

sub http_method { 'GET'; }

sub url { 'http://api.flickr.com/services/rest/'; }

sub query_class { 'WebService::Flickr::Test::Echo::Query'; }

sub query_fields { [
    'api_key'
]; }

sub default_param { {
    'method' => 'flickr.test.echo'
}; }

sub notnull_param { [
    'method', 'api_key'
]; }

sub elem_class { 'WebService::Flickr::Test::Echo::Element'; }

sub root_elem { 'rsp'; }

sub elem_fields { {
    'err' => ['code', 'msg'],
    'rsp' => ['stat', 'method', 'api_key', 'stat', 'err'],

}; }

sub force_array { [
    
]; }

# __PACKAGE__->mk_query_accessors();

@WebService::Flickr::Test::Echo::Query::ISA = qw( Class::Accessor::Fast );
WebService::Flickr::Test::Echo::Query->mk_accessors( @{query_fields()} );

# __PACKAGE__->mk_elem_accessors();

@WebService::Flickr::Test::Echo::Element::ISA = qw( Class::Accessor::Children::Fast );
WebService::Flickr::Test::Echo::Element->mk_ro_accessors( root_elem() );
WebService::Flickr::Test::Echo::Element->mk_child_ro_accessors( %{elem_fields()} );

=head1 NAME

WebService::Flickr::Test::Echo - Flickr Services: Test API Methods "echo" API

=head1 SYNOPSIS

    use WebService::Flickr::Test;
    
    my $service = WebService::Flickr::Test->new();
    
    my $param = {
        'api_key' => $ENV{'FLICKR_API_KEY'},
    };
    my $res = $service->echo( %$param );
    my $data = $res->root;
    print "stat: $data->stat\n";
    print "method: $data->method\n";
    print "api_key: $data->api_key\n";
    print "...\n";

=head1 DESCRIPTION

This module is a interface for the C<echo> API.
It accepts following query parameters to make an request.

    my $param = {
        'api_key' => 'XXXXXXXX',
    };
    my $res = $service->echo( %$param );

C<$service> above is an instance of L<WebService::Flickr::Test>.

=head1 METHODS

=head2 root

This returns the root element of the response.

    my $root = $res->root;

You can retrieve each element by the following accessors.

    $root->stat
    $root->method
    $root->api_key


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
