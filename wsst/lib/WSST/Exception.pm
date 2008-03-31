package WSST::Exception;

use strict;
use overload '""' => 'to_string';
use Carp;

our $VERSION = '0.0.1';

sub new {
    my $class = shift;
    my $self = {@_};
    return bless($self, $class);
}

sub to_string {
    my $self = shift;
    return $self->{detail} if $WSST::COMMAND_OPTS->{verbose};
    return $self->{msg};
}

sub raise {
    my $class = shift;
    my $msg = join("", map {"$_"} @_);
    die $class->new(msg=>$msg, detail=>Carp::longmess($msg));
}

=head1 NAME

WSST::Exception - Exception class of WSST

=head1 DESCRIPTION

Exception represents error.

=head1 METHODS

=head2 new

Constructor.

=head2 to_string

Returns error message.

=head2 raise

Raise error (call die).
This method automatically sets detail message
as stack trace by Carp::longmess.

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
