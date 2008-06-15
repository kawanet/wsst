package WSST::Schema::Test;

use strict;
use base qw(WSST::Schema::Base);
__PACKAGE__->mk_accessors(qw(type name params));

our $VERSION = '0.1.0';

1;
