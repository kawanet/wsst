package WSST::Schema::Param;

use strict;
use base qw(WSST::Schema::Base);
__PACKAGE__->mk_accessors(qw(name title desc type require));

use constant BOOL_FIELDS => qw(require);

our $VERSION = '0.1.0';

1;
