package WSST::SchemaParserManager;

use strict;
use File::Basename qw(fileparse);
use WSST::Exception;
use WSST::SchemaParser;
use WSST::BuiltinSchemaParser;
use WSST::PluginManager;

our $VERSION = '0.0.1';

my $SINGLETON_INSTANCE = undef;

sub new {
    my $class = shift;
    
    my $self = {
        parsers => [],
        parser_type_map => {},
    };
    
    return bless($self, $class);
}

sub get_schema_parser {
    my ($self, $path) = @_;
    my @exts = sort keys %{$self->{parser_type_map}};
    my ($fname, $dir, $ext) = fileparse($path, @exts);
    unless ($self->{parser_type_map}->{$ext}) {
        WSST::Exception->raise("parser not found: $path");
    }
    return $self->{parser_type_map}->{$ext};
}

sub instance {
    my $class = shift;
    
    unless ($SINGLETON_INSTANCE) {
        $class->init();
    }
    
    return $SINGLETON_INSTANCE;
}

sub init {
    my $class = shift;
    
    my $self = $SINGLETON_INSTANCE = $class->new();

    {
        my $builtin = WSST::BuiltinSchemaParser->new();
        push(@{$self->{parsers}}, $builtin);
        foreach my $type (@{$builtin->types}) {
            $self->{parser_type_map}->{$type} = $builtin;
        }
    }
    
    my $pm = WSST::PluginManager->instance;
    foreach my $plugin (@{$pm->{plugins}}) {
        next unless $plugin->isa("WSST::SchemaParser");
        push(@{$self->{parsers}}, $plugin);
        foreach my $type (@{$plugin->types}) {
            $self->{parser_type_map}->{$type} = $plugin;
        }
    }
}

=head1 NAME

WSST::SchemaParserManager - SchemaParserManager class of WSST

=head1 DESCRIPTION

SchemaParserManager is a "Singleton" class.
This class manages schema parsers.

=head1 METHODS

=head2 new

Constructor.

=head2 get_schema_parser

Returns schema parser object for the specified filepath.

=head2 instance

Returns "Singleton" instance.

=head2 init

Initialize this class.

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
