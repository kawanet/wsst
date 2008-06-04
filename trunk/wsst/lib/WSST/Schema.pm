package WSST::Schema;

use strict;
use Storable qw(dclone);

our $VERSION = '0.0.2';

sub new {
    my $class = shift;
    my $data = shift || {};
    my $self = {
        lang => $ENV{WSST_LANG},
        data => WSST::Schema::Data->new($data),
    };
    bless($self, $class);
    $self->_update_lang() if $self->{lang};
    return $self;
}

sub clone_data {
    my $self = shift;
    return dclone($self->data);
}

sub data {
    my $self = shift;
    return $self->{data};
}

sub lang {
    my $self = shift;
    if (@_) {
        $self->{lang} = shift;
        $self->_update_lang();
    }
    return $self->{lang};
}

sub _update_lang {
    my $self = shift;
    
    my $lang = $self->{lang} || "default";
    my $hash_list = [$self->{data}];
    
    while (my $hash = shift(@$hash_list)) {
        foreach my $key (keys %$hash) {
            next if $key =~ /_m17n$/;
            my $key_m17n = $key . "_m17n";
            if ($hash->{$key_m17n} && ref($hash->{$key_m17n}) eq 'HASH') {
                $hash->{$key_m17n}->{default} = $hash->{$key}
                    unless exists $hash->{$key_m17n}->{default};
                $hash->{$key} = $hash->{$key_m17n}->{$lang};
                next;
            }
            if (ref($hash->{$key}) eq 'HASH') {
                push(@$hash_list, $hash->{$key});
                next;
            }
            if (ref($hash->{$key}) eq 'ARRAY') {
                foreach my $val (@{$hash->{$key}}) {
                    push(@$hash_list, $val)
                        if ref($val) eq 'HASH';
                }
            }
        }
    }
}

package WSST::Schema::Base;

use strict;
use base qw(Class::Accessor::Fast);

use constant BOOL_FIELDS => ();

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    foreach my $fld ($class->BOOL_FIELDS) {
        $self->{$fld} = ($self->{$fld} eq "true");
    }
    return $self;
}

package WSST::Schema::Data;

use strict;
use base qw(WSST::Schema::Base);
__PACKAGE__->mk_accessors(qw(company_name service_name version title abstract
                             license author see_also copyright methods));

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

package WSST::Schema::Method;

use strict;
use base qw(WSST::Schema::Base);
__PACKAGE__->mk_accessors(qw(name title desc url params params_footnotes return
                             return_footnotes error error_footnotes tests
                             sample_response));

sub new {
    my $class = shift;
    my $self = $class->SUPER::new(@_);
    if ($self->{params}) {
        foreach my $param (@{$self->{params}}) {
            $param = WSST::Schema::Param->new($param);
        }
    }
    $self->{return} = WSST::Schema::Return->new($self->{return});
    $self->{error} = WSST::Schema::Error->new($self->{error});
    if ($self->tests) {
        foreach my $test (@{$self->{tests}}) {
            $test = WSST::Schema::Test->new($test);
        }
    }
    foreach my $fld_base (qw(params return error)) {
        my $fld = "${fld_base}_footnotes";
        next unless defined $self->{$fld};
        my $ref = ref $self->{$fld};
        if ($ref eq 'ARRAY') {
            my $n = 1;
            $self->{$fld} = [map {{name=>$n++, value=>$_}} @{$self->{$fld}}];
        } elsif ($ref eq 'HASH') {
            $self->{$fld} = [map {{name=>$_, value=>$self->{$fld}->{$_}}}
                             sort keys %{$self->{$fld}}];
        }
    }
    return $self;
}

sub sample_query {
    my $self = shift;
    $self->{sample_query} = $_[0] if scalar(@_);
    return $self->{sample_query} if defined $self->{sample_query};
    my $good_test = $self->first_good_test || return;
    require URI;
    my $url = URI->new($self->url);
    my $params = {%{$good_test->params}};
    foreach my $key (keys %$params) {
        $params->{$key} =~ s/^\$(.*)$/$ENV{$1}||'XXXXXXXX'/e;
    }
    $url->query_form(%$params);
    my $sample_query = {
        url => $url->as_string,
    };
    return $sample_query;
}

sub first_good_test {
    my $self = shift;
    return unless defined $self->tests;
    foreach my $test (@{$self->tests}) {
        return $test if $test->type eq 'good';
    }
    return undef;
}

package WSST::Schema::Param;

use strict;
use base qw(WSST::Schema::Base);
__PACKAGE__->mk_accessors(qw(name title desc type require));

use constant BOOL_FIELDS => qw(require);

package WSST::Schema::Node;

use strict;
use base qw(WSST::Schema::Base);
__PACKAGE__->mk_accessors(qw(name title desc examples type children multiple
                             nullable));
__PACKAGE__->mk_ro_accessors(qw(parent depth));

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

use constant BOOL_FIELDS => qw(multiple nullable);

package WSST::Schema::Return;

use strict;
use base qw(WSST::Schema::Node);
__PACKAGE__->mk_accessors(qw(options page_total_entries page_current_page
                             page_entries_per_page));

use constant BOOL_FIELDS => qw(multiple nullable page_total_entries
                               page_current_page page_entries_per_page);

package WSST::Schema::Error;

use strict;
use base qw(WSST::Schema::Node);
__PACKAGE__->mk_accessors(qw(values error_message error_message_map));

use constant BOOL_FIELDS => qw(multiple nullable error_message);

package WSST::Schema::Test;

use strict;
use base qw(WSST::Schema::Base);
__PACKAGE__->mk_accessors(qw(type name params));


=head1 NAME

WSST::Schema - Schema class of WSST

=head1 DESCRIPTION

Schema is container class of parsed schema data.

=head1 METHODS

=head2 new

Constructor.

=head2 clone_data

Returns schema data which copied deeply.

=head2 lang

Accessor method for lang value.

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
