package WSST::Schema::Base;

use strict;
use base qw(Class::Accessor::Fast);

use constant BOOL_FIELDS => ();

our $VERSION = '0.1.0';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    foreach my $fld ($class->BOOL_FIELDS) {
        $self->{$fld} = ($self->{$fld} && $self->{$fld} eq "true");
    }
    return $self;
}

1;
