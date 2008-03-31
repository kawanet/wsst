package WSST::AbstractCommand;

use strict;
use base qw(WSST::Command);
use WSST::Exception;

our $VERSION = '0.0.1';

sub new {
    my $class = shift;
    my $self = {};
    return bless($self, $class);
}

sub command_names {
    my $self = shift;
    
    my $cmds = [];
    my $prefix = $self->command_method_prefix;
    my $class = ref($self);
    no strict 'refs';
    foreach my $def (sort keys %{"${class}::"}) {
        next unless $def =~ /^$prefix(.+)$/;
        my $cmd = $1;
        next unless $self->can($def);
        push(@$cmds, $cmd);
    }
    
    return $cmds;
}

sub execute {
    my $self = shift;
    my $name = shift;
    my $args = shift;
    my $prefix = $self->command_method_prefix;
    my $method = $self->can("$prefix$name")
        || WSST::Exception->raise("invalid command: $name");
    return $self->$method($args);
}

sub command_method_prefix {
    return "cmd_";
}

=head1 NAME

WSST::AbstractCommand - AbstractCommand class of WSST

=head1 DESCRIPTION

AbstractCommand is abstract class
which auto generate command_names
and auto execute specified command.

=head1 METHODS

=head2 new

Constructor.

=head2 command_names

Returns command names by looking for method
of the name with prefix that command_method_prefix returns.

=head2 execute

Execute command of the specified name with args
and return exit code.

=head2 command_method_prefix

Returns prefix of command method name.

By default it returns "cmd_".
If you want to change this value,
override it in your subclass.

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
