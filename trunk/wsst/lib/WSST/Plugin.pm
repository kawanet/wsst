package WSST::Plugin;

use strict;
use File::Basename qw(dirname);

our $VERSION = "0.0.1";

sub new {
    my $class = shift;
    
    my $self = {@_};
    $self->{init_file} ||= (caller())[1];
    $self->{base_dir} ||= dirname($self->{init_file});
    
    return bless($self, $class);
}

sub name {
    my $self = shift;
    return ref $self;
}

=head1 NAME

WSST::Plugin - Plugin class of WSST

=head1 DESCRIPTION

Plugin is base class for plugins.
All plugin must extends this class.

=head1 METHODS

=head2 new

Constructor.

=head2 name

Returns the plugin name.
(Default: returns class name by 'ref $self')

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
