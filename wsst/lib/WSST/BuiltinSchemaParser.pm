package WSST::BuiltinSchemaParser;

use strict;
use base qw(WSST::SchemaParser);
use YAML ();
use WSST::Exception;

our $VERSION = '0.0.1';

sub new {
    my $class = shift;
    my $self = {};
    return bless($self, $class);
}

sub types {
    return [".yml", ".yaml"];
}

sub parse {
    my $self = shift;
    my $path = shift;
    
    my $data = eval {
        YAML::LoadFile($path);
    };
    if ($@) {
        WSST::Exception->raise($@);
    }
    
    return WSST::Schema->new($data);
}

=head1 NAME

WSST::BuiltinSchemaParser - BuiltinSchemaParser class of WSST

=head1 DESCRIPTION

BuiltinSchemaParser is builtin YAML schema parser.

=head1 METHODS

=head2 new

Constructor.

=head2 types

Returns [".yml", ".yaml"]

=head2 parse

Parses YAML schema file, and returns Schema object.

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
