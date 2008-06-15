package WSST::Schema::Return;

use strict;
use base qw(WSST::Schema::Node);
__PACKAGE__->mk_accessors(qw(options page_total_entries page_current_page
                             page_entries_per_page));

use constant BOOL_FIELDS => qw(multiple nullable page_total_entries
                               page_current_page page_entries_per_page);

our $VERSION = '0.1.0';

1;
