package WSST::GeneratorManager;

use strict;
use WSST::Generator;
use WSST::BuiltinGenerator;
use WSST::PluginManager;

our $VERSION = '0.0.1';

my $SINGLETON_INSTANCE = undef;

sub new {
    my $class = shift;
    
    my $self = {@_};
    $self->{generators} ||= [];
    $self->{generator_name_map} ||= {};
    $self->{generator_full_name_map} ||= {};
    
    return bless($self, $class);
}

sub get_generator {
    my $self = shift;
    my $name = shift;
    my $gen = $self->{generator_name_map}->{$name};
    $gen = $self->{generator_full_name_map}->{$name} unless $gen;
    return $gen;
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
    
    my $self = $SINGLETON_INSTANCE = $class->new(@_);

    {
        my $builtin = WSST::BuiltinGenerator->new();
        push(@{$self->{generators}}, $builtin);
        foreach my $n (@{$builtin->generator_names}) {
            my $fn = "__builtin__.$n";
            $self->{generator_name_map}->{$n} = $builtin;
            $self->{generator_full_name_map}->{$fn} = $builtin;
        }
    }

    my $pm = WSST::PluginManager->instance;
    foreach my $plugin (@{$pm->{plugins}}) {
        next unless $plugin->isa("WSST::Generator");
        push(@{$self->{generators}}, $plugin);
        my $pn = $plugin->name;
        foreach my $n (@{$plugin->generator_names}) {
            my $fn = "$pn.$n";
            $self->{generator_name_map}->{$n} = $plugin;
            $self->{generator_full_name_map}->{$fn} = $plugin;
        }
    }
}

=head1 NAME

WSST::GeneratorManager - GeneratorManager class of WSST

=head1 DESCRIPTION

GeneratorManager is a "Singleton" class.
This class manages generators.

=head1 METHODS

=head2 new

Constructor.

=head2 get_generator

Returns generator object of the specified name.

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
