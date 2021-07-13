@echo off

REM enforce this codepage so cmd errors would be readable in keil
chcp 20127 >NUL 2>NUL

REM I have to use .bat-file cause Keil can't directly call shell-script
REM if you have several bashes, please set env. variable GIT_BASH_PATH with a \ at the end
REM or, if you have one bash, you can add it in the PATH

"%GIT_BASH_PATH%bash.exe" --login "%~dp0\check_project.sh"  || goto :error

goto :EOF

:error
    echo --------------------
    echo "Error has occured when running check_project.bat!"
    echo "Please check environment variable GIT_BASH_PATH; it should contain path to bash with \ on the end"
    echo --------------------
    exit /B 1

