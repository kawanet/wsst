#!/bin/sh

die () {
    echo "$*" >&2
    exit 1
}
doit () {
    echo "\$ $*" >&2
    $* || die "[ERROR:$?]"
}

[ -f Makefile ] && doit make clean
doit perl Makefile.PL
[ -f MANIFEST ] || doit make manifest

egrep -v '^t/.*\.t$' MANIFEST > MANIFEST~
ls -t t/*.t | sort >> MANIFEST~
diff MANIFEST MANIFEST~ > /dev/null || doit /bin/mv -f MANIFEST~ MANIFEST
/bin/rm -f MANIFEST~

doit make
doit make disttest

main=`grep 'lib/.*pm$' < MANIFEST | head -1`
[ "$main" == "" ] && die "main module is not found in MANIFEST"
doit pod2text $main > README

doit make dist
doit /bin/rm -fr blib pm_to_blib

ls -lt *.tar.gz | head -1
