@echo off
if not exist "lst\pvs_dump.zip" (
    echo --------------------
    echo "PVS Studio dump file not found! Please, create it first!"
    echo --------------------
    exit /B 1
)


call "%~dp0\check_project.bat"
