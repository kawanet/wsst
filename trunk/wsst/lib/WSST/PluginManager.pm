package WSST::PluginManager;

use strict;
use WSST::Exception;

our $VERSION = '0.0.1';

my $SINGLETON_INSTANCE = undef;

sub new {
    my $class = shift;

    my $self = {@_};
    $self->{plugin_dir} ||= "plugins";
    $self->{plugins} ||= [];
    $self->{plugin_name_map} ||= {};
    
    return bless($self, $class);
}

sub get_plugin {
    my $self = shift;
    my $name = shift;
    return $self->{plugin_name_map}->{$name};
}

sub load_plugin {
    my $self = shift;
    my $path = shift;
    
    $path = "$path/init.pm" if -d $path;
    
    eval {
        local $self->{__plugin_parmas} = {
            init_file => $path,
        };
        require "$path";
    };
    if ($@) {
        WSST::Exception->raise("cannot load '$path': $@");
    }
}

sub find_plugins {
    my $self = shift;
    
    my $plugin_dir = $self->{plugin_dir};
    my $path_list = [];
    
    unless (opendir(DIR, $plugin_dir)) {
        WSST::Exception->raise("cannot opendir '$plugin_dir': $!");
    }

    while (my $ent = readdir(DIR)) {
        next if $ent =~ /^[\._]/;
        
        my $path = "$plugin_dir/$ent";
        if (-d $path) {
            next unless -r "$path/init.pm";
        } else {
            next unless $ent =~ /\.pm$/;
        }
        
        push(@$path_list, $path);
    }
    
    closedir(DIR);
    
    return [sort @$path_list];
}

sub register_plugin {
    my $class = shift;
    
    my $self = $class->instance;
    
    push(@_, (caller())[0]) unless @_;
    
    foreach my $pkg (@_) {
        my $plugin = $pkg->new(%{$self->{__plugin_params}});
        push(@{$self->{plugins}}, $plugin);
        $self->{plugin_name_map}->{$plugin->name} = $plugin;
    }
}

sub instance {
    my $class = shift;
    
    unless ($SINGLETON_INSTANCE) {
        $class->init();
    }
    
    return $SINGLETON_INSTANCE;
}

sub init {
    my $class = shift;
    my $self = $SINGLETON_INSTANCE = $class->new(@_);
    
    my $path_list = $self->find_plugins();
    
    foreach my $path (@$path_list) {
        $self->load_plugin($path);
    }
}

=head1 NAME

WSST::PluginManager - PluginManager class of WSST

=head1 DESCRIPTION

PluginManager is a "Singleton" class.
This class manages plugins.

=head1 METHODS

=head2 new

Private constructor.

=head2 get_plugin

Returns plugin object of the specified name.

=head2 load_plugin

Load plugin of the specified file/directory.

=head2 find_plugins

Find plugins from "plugin_dir".

=head2 register_plugin

Register plugin.
Plugin class must call this method.

example:
WSST::PluginManager->register_plugin();

=head2 instance

Returns "Singleton" instance.

=head2 init

Initialize this class.
Create instance and find/load plugins.

=head1 SEE ALSO

http://code.google.com/p/wsst/

=head1 AUTHORS

Mitsuhisa Oshikawa <mitsuhisa@gmail.com>
Yusuke Kawasaki <u-suke@kawa.net>

=head1 COPYRIGHT AND LICENSE

Copyright 2008 WSS Project Team

=cut
1;
