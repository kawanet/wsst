package WSST::Schema::Error;

use strict;
use base qw(WSST::Schema::Node);
__PACKAGE__->mk_accessors(qw(values error_message error_message_map));

use constant BOOL_FIELDS => qw(multiple nullable error_message);

our $VERSION = '0.1.0';

1;
