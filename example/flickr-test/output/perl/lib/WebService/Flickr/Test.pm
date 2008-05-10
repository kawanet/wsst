package WebService::Flickr::Test;

use strict;
use base qw( Class::Accessor::Fast );
use vars qw( $VERSION );
$VERSION = '0.0.1';

use WebService::Flickr::Test::Echo;
use WebService::Flickr::Test::Login;


my $TPPCFG = [qw( user_agent lwp_useragent http_lite utf8_flag )];
__PACKAGE__->mk_accessors( @$TPPCFG, 'param' );

sub new {
    my $package = shift;
    my $self    = {@_};
    $self->{user_agent} ||= __PACKAGE__."/$VERSION ";
    bless $self, $package;
    $self;
}

sub add_param {
    my $self = shift;
    my $param = $self->param() || {};
    %$param = ( %$param, @_ ) if scalar @_;
    $self->param($param);
}

sub get_param {
    my $self = shift;
    my $key = shift;
    my $param = $self->param() or return;
    $param->{$key} if exists $param->{$key};
}

sub init_treepp_config {
    my $self = shift;
    my $api  = shift;
    my $treepp = $api->treepp();
    foreach my $key ( @$TPPCFG ) {
        next unless exists $self->{$key};
        next unless defined $self->{$key};
        $treepp->set( $key => $self->{$key} );
    }
}

sub init_query_param {
    my $self = shift;
    my $api  = shift;
    my $param = $self->param();
    foreach my $key ( keys %$param ) {
        next unless defined $param->{$key};
        $api->add_param( $key => $param->{$key} );
    }
}

sub echo {
    my $self = shift or return;
    $self = $self->new() unless ref $self;
    my $api = WebService::Flickr::Test::Echo->new();
    $self->init_treepp_config( $api );
    $self->init_query_param( $api );
    $api->add_param( @_ );
    $api->request();
    $api;
}

sub login {
    my $self = shift or return;
    $self = $self->new() unless ref $self;
    my $api = WebService::Flickr::Test::Login->new();
    $self->init_treepp_config( $api );
    $self->init_query_param( $api );
    $api->add_param( @_ );
    $api->request();
    $api;
}


=head1 NAME

WebService::Flickr::Test - An Interface for Flickr Services: Test API Methods

=head1 SYNOPSIS

    use WebService::Flickr::Test;
    
    my $service = WebService::Flickr::Test->new();
    
    my $param = {
        'api_key' => $ENV{'FLICKR_API_KEY'},
    };
    my $res = $service->echo( %$param );
    my $root = $res->root;
    printf("stat: %s\n", $root->stat);
    printf("method: %s\n", $root->method);
    printf("api_key: %s\n", $root->api_key);
    print "...\n";

=head1 DESCRIPTION

Yet another interface for Flickr Services powered by WSST

=head1 METHODS

=head2 new

This is the constructor method for this class.

    my $service = WebService::Flickr::Test->new();

This accepts optional parameters.

    my $conf = {
        utf8_flag => 1,
        param => {
            # common parameters of this web service 
        },
    };
    my $service = WebService::Flickr::Test->new( %$conf );

=head2 add_param

Add common parameter of tihs web service.

    $service->add_param( param_key => param_value );

You can add multiple parameters by calling once.

    $service->add_param( param_key1 => param_value1,
                         param_key2 => param_value2,
                         ...);

=head2 get_param

Returns common parameter value of the specified key.

    my $param_value = $service->get( 'param_key' );

=head2 echo

This makes a request for C<echo> API.
See L<WebService::Flickr::Test::Echo> for details.

    my $res = $service->echo( %$param );

=head2 login

This makes a request for C<login> API.
See L<WebService::Flickr::Test::Login> for details.

    my $res = $service->login( %$param );

=head2 utf8_flag / user_agent / lwp_useragent / http_lite

This modules uses L<XML::TreePP> module internally.
Following methods are available to configure it.

    $service->utf8_flag( 1 );
    $service->user_agent( 'Foo-Bar/1.0 ' );
    $service->lwp_useragent( LWP::UserAgent->new() );
    $service->http_lite( HTTP::Lite->new() );

=head1 SEE ALSO

http://www.flickr.com/services/api/

=head1 AUTHOR

Yusuke Kawasaki <u-suke [at] kawa.net>

=head1 COPYRIGHT

Copyright 2008 Yusuke Kawasaki

=cut
1;
