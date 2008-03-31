package WSST::Plugin::TestPlugin2;

use strict;
use base qw(WSST::Plugin);
use WSST::PluginManager;

our $VERSION = '0.0.1';

WSST::PluginManager->register_plugin();

sub name {
    return 'test_plugin2';
}

1;
