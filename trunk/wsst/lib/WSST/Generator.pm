package WSST::Generator;

use strict;
use WSST::Schema;

our $VERSION = '0.0.1';

sub generator_names;

sub generate;

=head1 NAME

WSST::Generator - Generator interface of WSST

=head1 DESCRIPTION

Generator is interface of library generator.

=head1 METHODS

=head2 generator_names

Returns generator name and alias
like "perl", "perl5", "php", "php5".

=head2 generate

Generate library and return generated file names.

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
