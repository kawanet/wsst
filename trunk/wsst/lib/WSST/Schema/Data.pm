package WSST::Schema::Data;

use strict;
use base qw(WSST::Schema::Base);
__PACKAGE__->mk_accessors(qw(company_name service_name version title abstract
                             license author see_also copyright methods));

use WSST::Schema::Method;

our $VERSION = '0.1.0';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    if ($self->{methods}) {
        foreach my $method (@{$self->{methods}}) {
            $method = WSST::Schema::Method->new($method);
        }
    }
    return $self;
}

sub meta_spec {
    my $self = shift;
    $self->{'meta-spec'} = $_[0] if scalar(@_);
    return $self->{'meta-spec'};
}

1;
