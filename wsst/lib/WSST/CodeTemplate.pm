package WSST::CodeTemplate;

use strict;
use Text::Template;

our $VERSION = '0.0.1';

BEGIN {
    *Text::Template::_install_hash = \&_my_install_hash;
}

our $DELIMITERS = [ '<%[', ']%>' ];

sub new {
    my $class = shift;
    
    my $self = {@_};
    $self->{tmpl_dirs} ||= [];
    $self->{tmpl_prefix} ||= "";
    $self->{vars} ||= {};
    
    bless($self, $class);
    
    $self->{vars}->{include} = sub { $self->expand(@_); };
    
    return $self;
}

sub get {
    my $self = shift;
    my $key = shift;
    return $self->{vars}->{$key};
}

sub set {
    my $self = shift;
    %{$self->{vars}} = (%{$self->{vars}}, @_);
}

sub expand {
    my $self = shift;
    my $name = shift;
    my %local_vars = @_;
    
    my $fpath = $self->get_template_path($name) || return;
    my $tmpl = $self->new_template($fpath);
    
    my $vars = {%{$self->{vars}}, %local_vars};
    
    my $res = $tmpl->fill_in(HASH => $vars);
    
    foreach my $key (keys %$vars) {
        next if exists $local_vars{$key};
        $self->{vars}->{$key} = $vars->{$key};
    }
    
    return $res;
}

sub new_template {
    my $self = shift;
    my $fpath = shift;
    
    my $src = undef;
    {
        open(TMPL, $fpath)
            || WSST::Exception->raise("failed new_template: ", $!);
        local $/ = undef;
        $src = <TMPL>;
        close(TMPL);
    }

    $src =~ s/\r?\n/\n/sg;

    my $tmpl = new Text::Template(DELIMITERS => $DELIMITERS,
                                  TYPE => 'STRING',
                                  SOURCE => $src);

    WSST::Exception->raise("failed new_template: ", $!)
        unless $tmpl;

    return $tmpl;
}

sub get_template_path {
    my $self = shift;
    my $name = shift;
    
    return $name if -r $name;
    
    foreach my $dir (@{$self->{tmpl_dirs}}) {
        my $fpath = "$dir/$self->{tmpl_prefix}$name";
        return $fpath if -r $fpath;
        $fpath = "$fpath.tmpl";
        return $fpath if -r $fpath;
    }
    
    return undef;
}

sub _my_install_hash {
    my $hashlist = shift;
    my $dest = shift;
    if (UNIVERSAL::isa($hashlist, 'HASH')) {
        $hashlist = [$hashlist];
    }
    my $hash;
    foreach $hash (@$hashlist) {
        my $name;
        foreach $name (keys %$hash) {
            my $val = $hash->{$name};
            no strict 'refs';
            if (! defined $val) {
                delete ${"$ {dest}::"}{$name};
            } elsif (ref $val) {
                *{"$ {dest}::$name"} = $val;
            } else {
                *{"$ {dest}::$name"} = \$val;
            }
        }
    }
}

=head1 NAME

WSST::CodeTemplate - CodeTemplate class of WSST

=head1 DESCRIPTION

CodeTemplate is class encapsulating the Text::Template.

=head1 METHODS

=head2 new

Constructor.

=head2 get

Returns template variable of the specified name.

=head2 set

Set template variable.

=head2 expand

Expand the specified template file.

=head2 new_template

Create new Text::Template object.

=head2 get_template_path

Returns template file path.

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
