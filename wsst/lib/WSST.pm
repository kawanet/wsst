package WSST;

use strict;
use base qw(Exporter);
use vars qw(@EXPORT);
use File::Basename qw(dirname);

use WSST::PluginManager;
use WSST::CommandManager;

@EXPORT = qw(generate);

unless ($ENV{WSST_HOME}) {
    my $path = $INC{'WSST.pm'};
    my $lib_dir = dirname($path);
    $ENV{WSST_HOME} = "$lib_dir/..";
}

$ENV{WSST_PLUGIN_DIR} ||= "$ENV{WSST_HOME}/plugins";

sub generate {
    my $tcm = WSST::CommandManager->instance;
    
    my $cmd = $tcm->get_command('generate')
      || WSST::Exception->raise("command not found: 'generate'");
    
    return $cmd->execute('generate', \@ARGV);
}

1;
