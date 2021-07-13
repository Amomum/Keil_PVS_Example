@echo off

rem enforce this codepage so cmd errors would be readable in keil
chcp 20127 >NUL 2>NUL

rem ���� ������ ����� ������ ������, ��� ���� �� ����� ��������� .sh ��������
rem >NUL 2>NUL ��� ��������� ������, ����� �� �������� ��� �����
rem ���� � ��� ��������� �����, ���������� ���������� ��������� %GIT_BASH_PATH% � �� �������� \ �� �����

"%GIT_BASH_PATH%bash.exe" --login "%~dp0\check_project.sh"  || goto :error


goto :EOF

rem ��������� ������ - ������� ����� � ������
:error
    echo --------------------
    echo "Error has occured when running check_project.bat!"
    echo "Please check environment variable GIT_BASH_PATH; it should contain path to bash with \ on the end"
    echo --------------------
    exit /B 1

