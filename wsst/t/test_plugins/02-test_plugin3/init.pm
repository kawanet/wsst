package WSST::Plugin::TestPlugin3;

use strict;
use base qw(WSST::Plugin WSST::Generator);
use WSST::PluginManager;

our $VERSION = '0.0.1';

WSST::PluginManager->register_plugin();

sub name {
    return 'test_plugin3';
}

sub generator_names {
    return ["test_plugin3"];
}

sub generate {
    my $self = shift;
    my $name = shift;
    my $schema = shift;
    my $opts = shift || {};

    my $result = [];
    
    push(@$result, "test_plugin3");

    return $result;
}

1;
