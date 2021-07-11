
# crude check if any file was added or removed from project
# search for changes in git diff that include <FileName> tag
was_changed=$(git diff *.uvproj* | grep "[+,-]\s*<FileName>" | sed -e 's#</*FileName>##g')

if [[ -n "$was_changed" ]]; then
    echo "-------------------"
    echo "PVS Studio warning:"
    echo --------------------
    echo "Project file was changed! Some files were added or removed:"
    echo "$was_changed"
    echo "You may want to generate new dump-file for PVS-studio"
    echo "For this:"
    echo "1) Go to Project->Options->Listing and enable compiler and preprocessor listing"
    echo "2) Go to Project->Options->User, deselect usual scripts and select before and after script with _dump"
    echo "3) Go to Edit->Configuration->Other and Disable parallel build"
    echo "4) Rebuild all"
    echo "Please note, that this warning will go away only after you commited changes in project file!"
    echo "-------------------"
fi