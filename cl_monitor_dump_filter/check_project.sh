#!/bin/bash

# crude check if any file was added or removed from project
# search for changes in git diff that include <FileName> tag
was_changed=$(git diff *.uvproj* | grep "[+,-]\s*<FileName>" | sed -e 's#</*FileName>##g')

if [[ -n "$was_changed" ]]; then
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "Warning when running PVS Studio:"
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "--------------------------"
    echo "Project file was changed! Some files were added or removed:"
    echo "$was_changed"
    echo "You may want to generate new dump-file for PVS-studio"
    echo "For this:"
    echo "1) Go to Project->Options->User, "
    echo "2) Enable 'Before Compile C/C++ File' script and 'Before Build/Rebuild' script"
    echo "3) Rebuild all"
    echo "4) Disable those scripts once again"
    echo "Please note, that this warning will go away only after you commited changes in project file!"
    echo "--------------------------"
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%"
    echo "%%%%%%%%%%%%%%%%%%%%%%%%%%"
fi