@echo off

rem enforce this codepage so cmd errors would be readable in keil
chcp 20127 >NUL 2>NUL

rem Ётот батник нужен просто потому, что  ейл не умеет запускать .sh напр€мую
rem >NUL 2>NUL это затыкание вывода, чтобы не засор€ть лог билда
rem если у вас несколько башей, установите переменную окружени€ %GIT_BASH_PATH% и не забудьте \ на конце

"%GIT_BASH_PATH%bash.exe" --login "%~dp0\check_project.sh"  || goto :error


goto :EOF

rem ѕроизошла ошибка - выводим текст и падаем
:error
    echo --------------------
    echo "Error has occured when running check_project.bat!"
    echo "Please check environment variable GIT_BASH_PATH; it should contain path to bash with \ on the end"
    echo --------------------
    exit /B 1

