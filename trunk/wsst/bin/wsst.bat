@echo off

set BIN_DIR=%~dp0
set LIB_DIR=%BIN_DIR%\..\lib

perl -I %LIB_DIR% %BIN_DIR%\wsst.pl %*
