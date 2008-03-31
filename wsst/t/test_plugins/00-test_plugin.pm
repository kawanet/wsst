package WSST::Plugin::TestPlugin;

use strict;
use base qw(WSST::Plugin);
use WSST::PluginManager;

our $VERSION = '0.0.1';

WSST::PluginManager->register_plugin();

1;
