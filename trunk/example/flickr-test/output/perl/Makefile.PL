use strict;
use ExtUtils::MakeMaker;

my $opt = {
    NAME                =>  'WebService::Flickr::Test',
    VERSION_FROM        =>  'lib/WebService/Flickr/Test.pm',
    PREREQ_PM           =>  {
        'Test::More'        =>  '0',
        'Class::Accessor'   =>  '0',
        'Class::Accessor::Children'   =>  '0',
        'XML::OverHTTP'     =>  '0',
    },
    AUTHOR              => 'Yusuke Kawasaki <u-suke [at] kawa.net>',
};

$opt->{ABSTRACT} =<<END_OF_ABSTRACT_TEXT;
Yet another interface for Flickr Services powered by WSST
END_OF_ABSTRACT_TEXT

my $mm = $ExtUtils::MakeMaker::VERSION;
$mm =~ s/[^\d\.]+//g;
$opt->{LICENSE} = 'BSD' if ( $mm >= 6.3001 );

WriteMakefile( %$opt );
