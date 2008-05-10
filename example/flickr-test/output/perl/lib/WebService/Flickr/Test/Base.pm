package WebService::Flickr::Test::Base;
use strict;
use base qw( XML::OverHTTP );
use vars qw( $VERSION );
$VERSION = '0.10';

use Class::Accessor::Children::Fast;

sub attr_prefix { ''; }

sub is_error {
    my $self = shift;
    my $root = $self->root();
    return $root ? 0 : 1;
}

=head1 NAME

WebService::Flickr::Test::Base - Base class for Flickr Services: Test API Methods

=head1 DESCRIPTION

This is a base class for Flickr Services: Test API Methods.
L<WebService::Flickr::Test> uses this internally.

=head1 COPYRIGHT

Copyright 2008 Yusuke Kawasaki

=cut
1;
