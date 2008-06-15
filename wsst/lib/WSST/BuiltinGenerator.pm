package WSST::BuiltinGenerator;

use strict;
use base qw(WSST::Generator);
use File::Find qw(find);
use File::Basename qw(dirname);
use File::Path qw(mkpath);
use WSST::Exception;
use WSST::CodeTemplate;

our $VERSION = '0.0.2';

my $TMPL_PACKAGE_ID = 0;

sub new {
    my $class = shift;
    my $self = {};
    foreach my $base_dir (@INC) {
        my $dir = "$base_dir/WSST/Templates";
        if (-d $dir) {
            $self->{tmpl_dir} = $dir;
            last;
        }
    }
    return bless($self, $class);
}

sub generator_names {
    my $self = shift;
    
    my $names = [];
    
    opendir(DIR, $self->{tmpl_dir})
        || WSST::Exception->raise("failed opendir('$self->{tmpl_dir}'): $!");
    while (my $ent = readdir(DIR)) {
        next if $ent =~ /^\./ || ! -d "$self->{tmpl_dir}/$ent";
        push(@$names, $ent);
    }
    closedir(DIR);
    
    return [sort @$names];
}

sub generate {
    my $self = shift;
    my $name = shift;
    my $schema = shift;
    my $opts = shift || {};

    my $result = [];
    
    my $vars = $schema->clone_data;
    foreach my $opt_var (@{$opts->{var}}) {
        my ($key, $val) = split(/=/, $opt_var, 2);
        $vars->{$key} = $val;
    }
    
    my $tmpl_dir = "$self->{tmpl_dir}/$name";
    my $tmpl = new WSST::CodeTemplate(tmpl_dirs => [$tmpl_dir],
                                      vars => $vars);
    
    my $odir = ($opts->{outdir} || "output") . "/$name";
    unless (-d $odir) {
        mkdir($odir) || WSST::Exception->raise("failed mkdir('$odir'): $!");
    }

    my $files = [];
    my $libs = [];
    my $wanted = sub {
        push(@$files, $File::Find::name) if /\.tmpl$/ && !/^inc_/;
        push(@$libs, $File::Find::name) if /\.pm$/;
    };
    find($wanted, $tmpl_dir);
    
    return [] unless @$files;
    
    foreach my $method (@{$tmpl->get('methods')}) {
        $method->{class_name} = ucfirst($method->{name});
        $method->{class_name} =~ s/_(.)/uc($1)/eg;
        $method->{interface_name} = $method->{name};
    }
    
    my $listeners = {};

    my $tmpl_pkg = undef;    
    if (@$libs) {
        my $tmpl_pkg_name = "TMPL" . $TMPL_PACKAGE_ID++;
        $tmpl_pkg = "WSST::BuiltinGenerator::$tmpl_pkg_name";
        {
            no strict 'refs';
            *{"${tmpl_pkg}::schema"} = \$schema;
            *{"${tmpl_pkg}::opts"} = \$opts;
            *{"${tmpl_pkg}::tmpl"} = \$tmpl;
            *{"${tmpl_pkg}::files"} = \$files;
            *{"${tmpl_pkg}::libs"} = \$libs;
            *{"${tmpl_pkg}::result"} = \$result;
            *{"${tmpl_pkg}::tmpl_dir"} = \$tmpl_dir;
            *{"${tmpl_pkg}::odir"} = \$odir;
            *{"${tmpl_pkg}::listeners"} = \$listeners;
        }
        foreach my $lib (@$libs) {
            eval qq{
                package ${tmpl_pkg};
                require '$lib';
            };
            if ($@) {
                warn __PACKAGE__ . ": library load error: $@\n";
            }
        }
        my $hash = \%{$WSST::BuiltinGenerator::{"${tmpl_pkg_name}::"}};
        foreach my $key (keys %$hash) {
            next if $tmpl->get($key);
            #$tmpl->set($key => $hash->{$key});
            $tmpl->set($key => \&{$hash->{$key}});
        }
    }
    
    foreach my $file (@$files) {
        my $ofile = $file;
        $ofile =~ s/^\Q$tmpl_dir\E//;
        $ofile =~ s/\.tmpl$//;
        $ofile =~ s/{([a-zA-Z_][a-zA-Z0-9_]*)}/$tmpl->get($1)||"{$1}"/eg;
        
        my $fdir = dirname($file);
        unshift(@{$tmpl->{tmpl_dirs}}, $fdir);
        if ($file =~ /{method\.([a-zA-Z_][a-zA-Z0-9_]*)}/) {
            foreach my $method (@{$tmpl->get('methods')}) {
                my $ofile2 = $ofile;
                $ofile2 =~ s/{method\.([a-zA-Z_][a-zA-Z0-9_]*)}/$method->{$1}||"{$1}"/eg;
                $ofile2 =~ s/{([a-zA-Z_][a-zA-Z0-9_]*)\((.*?)\)}/eval "${tmpl_pkg}::${1}($2)"/eg
                    if $tmpl_pkg;
                die $@ if $@;
                $ofile2 = $odir . $ofile2;
                
                $tmpl->set('method' => $method);
                
                my $tmpl_name = $file;
                $tmpl_name =~ s#^\Q$tmpl_dir/\E##;
                my $odata = $tmpl->expand($tmpl_name);
                
                my $osubdir = dirname($ofile2);
                unless (-d $osubdir) {
                    mkpath($osubdir)
                        || WSST::Exception->raise("failed mkpath('$osubdir'): $!");
                }
                
                open(OUT, ">$ofile2")
                    || WSST::Exception->raise("failed open('>$ofile2'): $!");
                print OUT $odata;
                close(OUT);

                push(@$result, $ofile2);
            }
        } else {
            $ofile =~ s/{([a-zA-Z_][a-zA-Z0-9_]*)\((.*?)\)}/eval "${tmpl_pkg}::${1}($2)"/eg
                if $tmpl_pkg;
            $ofile = $odir . $ofile;

            my $tmpl_name = $file;
            $tmpl_name =~ s#^\Q$tmpl_dir/\E##;
            my $odata = $tmpl->expand($tmpl_name);
            
            my $osubdir = dirname($ofile);
            unless (-d $osubdir) {
                mkpath($osubdir)
                    || WSST::Exception->raise("failed mkpath('$osubdir'): $!");
            }
            
            open(OUT, ">$ofile")
                || WSST::Exception->raise("failed open('>$ofile'): $!");
            print OUT $odata;
            close(OUT);
        
            push(@$result, $ofile);
        }
        shift(@{$tmpl->{tmpl_dirs}});
    }
    
    foreach my $func (@{$listeners->{post_generate}}) {
        &{$func}();
    }
    
    return $result;
}

=head1 NAME

WSST::BuiltinGenerator - BuiltinGenerate class of WSST

=head1 DESCRIPTION

BuiltinGenerator is a template base generator.
The generate method of this class looks for
the template file from the template directory,
and processes those files.

=head1 METHODS

=head2 new

Constructor.

=head2 generator_names

Returns generator name and alias.
This method returns subdirectory name of template directory.

If the structure of template directory is as follows,
["perl", "php"] is returned.

    templates/
    |-- perl/
    |   `-- ...
    `-- php/
        `-- ... 

=head2 generate

Generate library and return generated file names
by processing template files in template directory.

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
