package WSST::Command;

use strict;

our $VERSION = '0.0.1';

sub command_names;

sub execute;

=head1 NAME

WSST::Command - Command interface of WSST

=head1 DESCRIPTION

Command is interface of wsst subcommand.

=head1 METHODS

=head2 command_names

Returns command names like "generate".

=head2 execute

Execute command of the specified name with args
and return exit code.

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
