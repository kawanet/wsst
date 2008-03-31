package WSST::CommandManager;

use strict;
use WSST::BuiltinCommand;
use WSST::PluginManager;

our $VERSION = '0.0.1';

my $SINGLETON_INSTANCE = undef;

sub new {
    my $class = shift;

    my $self = {
        commands => [],
        command_name_map => {},
        command_full_name_map => {},
    };
    
    return bless($self, $class);
}

sub get_command {
    my $self = shift;
    my $name = shift;
    my $cmd = $self->{command_name_map}->{$name};
    $cmd = $self->{command_full_name_map}->{$name} unless $cmd;
    return $cmd;
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
        my $builtin = WSST::BuiltinCommand->new();
        push(@{$self->{commands}}, $builtin);
        foreach my $n (@{$builtin->command_names}) {
            my $fn = "__builtin__.$n";
            $self->{command_name_map}->{$n} = $builtin;
            $self->{command_full_name_map}->{$fn} = $builtin;
        }
    }
    
    my $pm = WSST::PluginManager->instance;
    foreach my $plugin (@{$pm->{plugins}}) {
        next unless $plugin->isa("WSST::Command");
        push(@{$self->{commands}}, $plugin);
        my $pn = $plugin->name;
        foreach my $n (@{$plugin->command_names}) {
            my $fn = "$pn.$n";
            $self->{command_name_map}->{$n} = $plugin;
            $self->{command_full_name_map}->{$fn} = $plugin;
        }
    }
}

=head1 NAME

WSST::CommandManager - CommandManager class of WSST

=head1 DESCRIPTION

CommandManager is a "Singleton" class.
This class manages commands.

=head1 METHODS

=head2 new

Constructor.

=head2 get_command

Returns command object of the specified name.

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
