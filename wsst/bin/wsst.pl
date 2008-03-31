#!/usr/bin/perl

package WSST;

use strict;
use File::Basename qw(dirname);
use WSST::PluginManager;
use WSST::CommandManager;
use WSST::SchemaParserManager;

our $VERSION = '0.0.1';

our $COMMAND_OPTS = {};

sub parse_command_opts {
    my $subcmd = "help";
    
    while (my $arg = shift(@ARGV)) {
        if ($arg =~ /^-/) {
            if ($arg =~ /^(-h|--help)$/) {
                $COMMAND_OPTS->{'help'} = 1;
            } elsif ($arg =~ /^(-v|--verbose)$/) {
                $COMMAND_OPTS->{'verbose'} = 1;
            } elsif ($arg =~ /^(-V|--version)$/) {
                $COMMAND_OPTS->{'version'} = 1;
            } elsif ($arg =~ /^(-D|--define)$/) {
                my $arg2 = shift(@ARGV) || next;
                my ($key, $val) = split(/=/, $arg2, 2);
                $COMMAND_OPTS->{defs}->{$key} = $val;
            } elsif ($arg =~ /^(-D|--define=)(.+)$/) {
                my $arg2 = $2;
                my ($key, $val) = split(/=/, $arg2, 2);
                $COMMAND_OPTS->{defs}->{$key} = $val;
            } elsif ($arg =~ /^(-L|--lang)$/) {
                my $arg2 = shift(@ARGV) || next;
                $COMMAND_OPTS->{lang} = $arg2;
            } elsif ($arg =~ /^(-L|--lang=)(.+)$/) {
                my $arg2 = $2;
                $COMMAND_OPTS->{lang} = $arg2;
            }
        } else {
            $subcmd = $arg;
            last;
        }
    }
    
    return $subcmd;
}

sub main {
    my $bin_dir = dirname($0);
    
    $COMMAND_OPTS->{defs} = {
        plugin_dir => "$bin_dir/../plugins",
        tmpl_dir => "$bin_dir/../templates",
    };
    
    my $cmd_name = parse_command_opts();
    $cmd_name = "help" if $COMMAND_OPTS->{help};
    
    my $ret = eval {
        my $pd = $COMMAND_OPTS->{defs}->{plugin_dir};
        WSST::PluginManager->init(plugin_dir=>$pd);
        
        my $tcm = WSST::CommandManager->instance;
        
        my $cmd = $tcm->get_command($cmd_name)
            || WSST::Exception->raise("command not found: '$cmd_name'");
        
        return $cmd->execute($cmd_name, \@ARGV);
    };
    if ($@) {
        print STDERR "Error: $@\n";
        exit(1);
    }
    
    exit($ret);
}

unless (caller()) {
    main();
}

=head1 NAME

wsst.pl - WebService Specification Schema Tool(WSST)

=head1 DESCRIPTION

WSST is a tool to generate libraries which manipulate web service.

=head1 METHODS

=head2 parse_command_opts

Parse command opts.
This function parses only "general" options.

=head2 main

Entry point of this program.

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
