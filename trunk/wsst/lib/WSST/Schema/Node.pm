package WSST::Schema::Node;

use strict;
use base qw(WSST::Schema::Base);
__PACKAGE__->mk_accessors(qw(name title desc examples type children multiple
                             nullable));
__PACKAGE__->mk_ro_accessors(qw(parent depth));

use constant BOOL_FIELDS => qw(multiple nullable);

our $VERSION = '0.1.0';

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    $self->{depth} = ($self->parent ? $self->parent->depth + 1 : 1);
    if ($self->{children}) {
        foreach my $node (@{$self->{children}}) {
            $node->{parent} = $self;
            $node = $class->new($node);
        }
    }
    return $self;
}

sub path {
    my $self = shift;
    my $min = shift || 0;
    my $path = [];
    for (my $p = $self; $p && $p->depth >= $min; $p = $p->parent) {
        unshift(@$path, $p);
    }
    return $path;
}

sub path_names {
    my $self = shift;
    my $min = shift || 0;
    return [map {$_->name} @{$self->path($min)}];
}

sub to_array {
    my $self = shift;

    my $array = [$self];
    my $stack = [[$self, 0]];
    while (my $val = pop(@$stack)) {
        my ($node, $i) = @$val;
        for (; $i < @{$node->{children}}; $i++) {
            my $child = $node->{children}->[$i];
            push(@$array, $child);
            if ($child->{children}) {
                push(@$stack, [$node, $i+1]);
                push(@$stack, [$child, 0]);
                last;
            }
        }
    }

    return $array;
}

1;
