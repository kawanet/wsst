package WSST::BuiltinCommand;

use strict;
use base qw(WSST::AbstractCommand);
use Getopt::Long qw(:config no_ignore_case);
use WSST::PluginManager;
use WSST::GeneratorManager;
use WSST::CommandManager;
use WSST::SchemaParserManager;

our $VERSION = '0.0.1';

sub cmd_generate {
    my $self = shift;
    my $args = shift;
    
    local @ARGV = @$args;
    my $opts = {};
    GetOptions($opts,
               "schema|s=s",
               "outdir|o=s",
               "lang|l=s@",
               "var|v=s@");

    my $path = $opts->{schema};
    WSST::Exception->raise("not specified schema") unless $path;
    WSST::Exception->raise("cannot read schema: '$path'") unless -r $path;
    
    {
        my $odir = $opts->{outdir} || 'output';
        WSST::Exception->raise("invalid output dir: '$odir'")
            unless -d $odir;
    }
    
    my $spm = WSST::SchemaParserManager->instance;
    my $sp = $spm->get_schema_parser($path);
    my $schema = $sp->parse($path);
    
    my $gm = WSST::GeneratorManager->instance;
    
    if ($opts->{lang}) {
        foreach my $gn (@{$opts->{lang}}) {
            my $g = $gm->get_generator($gn);
            print "[$gn]\n";
            my $paths = $g->generate($gn, $schema, $opts);
            print join("\n", @$paths), "\n\n";
        }
    } else {
        foreach my $gn (sort keys %{$gm->{generator_name_map}}) {
            my $g = $gm->{generator_name_map}->{$gn};
            print "[", ref($g), "#$gn]\n";
            my $paths = $g->generate($gn, $schema, $opts);
            print join("\n", @$paths), "\n\n";
        }
    }
    
    return 0;
}

sub cmd_help {
    my $self = shift;
    my $args = shift;
    
    print "usage: $0 [general opts...] subcmd [subcmd opts...]\n";
    print "\n";
    print "general opts:\n";
    print "  -h --help     show this help and exit.\n";
    print "  -v --verbose  show verbose message.\n";
    print "  -V --version  show program version and exit.\n";
    print "  -D --define=s define option value like key=val.\n";
    print "  -L --lang=s   specify language of schema.\n";
    print "\n";

    print "subcmd list:\n";
    my $tcm = WSST::CommandManager->instance;
    foreach my $cmd (sort keys %{$tcm->{command_name_map}}) {
        print "  - $cmd\n";
    }
    
    if ($WSST::COMMAND_OPTS->{verbose}) {
        print "\n";
        print "subcmd full names:\n";
        foreach my $cmd (sort keys %{$tcm->{command_full_name_map}}) {
            print "  - $cmd\n";
        }
    }
    
    return 0;
}

sub cmd_listplugins {
    my $self = shift;
    my $args = shift;
    
    my $pm = WSST::PluginManager->instance;
    
    my $cnt = scalar(@{$pm->{plugins}});
    print "plugins($cnt):\n";
    
    foreach my $plugin (@{$pm->{plugins}}) {
        printf("  - %s\n", $plugin->name);
    }
    
    return 0;
}

sub cmd_dumpschema {
    my $self = shift;
    my $args = shift;
    
    local @ARGV = @$args;
    my $opts = {};
    GetOptions($opts,
               "schema|s=s");
    
    my $path = $opts->{schema} || return 1;
    my $spm = WSST::SchemaParserManager->instance;
    my $sp = $spm->get_schema_parser($path);
    my $schema = $sp->parse($path);

    require Data::Dumper;
    print Data::Dumper::Dumper($schema);
    
    return 0;
}

sub cmd_listlangs {
    my $self = shift;
    my $args = shift;
    
    my $gm = WSST::GeneratorManager->instance;
    
    my $cnt = scalar(keys %{$gm->{generator_name_map}});
    print "langs($cnt):\n";
    
    foreach my $gn (sort keys %{$gm->{generator_name_map}}) {
        print "  - $gn\n";
    }
    
    if ($WSST::COMMAND_OPTS->{verbose}) {
        print "\n";
        print "lang full names:\n";
        foreach my $gn (sort keys %{$gm->{generator_full_name_map}}) {
            print "  - $gn\n";
        }
    }
    
    return 0;
}

sub cmd_version {
    my $self = shift;
    my $args = shift;
    
    print "WSST $WSST::VERSION\n";
    print "Copyright 2008 WSS Project Team\n";
    
    if ($WSST::COMMAND_OPTS->{verbose}) {
        print "\n";
        no strict 'refs';
        my $list = [map {$WSST::{$_}} sort grep {/::$/} keys %WSST::];
        while (my $ent = shift(@$list)) {
            my $cls = "$ent";
            next if $cls =~ /ISA::CACHE::$/;
            $cls =~ s/^\*//;
            $cls =~ s/::$//;
            print "${cls}: ";
            if (${$ent}{VERSION}) {
                print ${${$ent}{VERSION}}, "\n";
            } else {
                print "(NO VERSION)\n";
            }
            push(@$list, map {${$ent}{$_}} sort grep {/::$/} keys %{$ent});
        }
    }
}

=head1 NAME

WSST::BuiltinCommand - BuiltinCommand class of WSST

=head1 DESCRIPTION

BuiltinCommand provides builtin commands.

=head1 METHODS

=head2 cmd_generate

Generate library by using generator object.

=head2 cmd_help

Print help message.

=head2 cmd_listplugins

Print plugin list.

=head2 cmd_dumpschema

Dump schema object by using Data::Dumper.

=head2 cmd_listplugins

Print generatable lang(library) list.

=head2 cmd_listplugins

Print version message.

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
