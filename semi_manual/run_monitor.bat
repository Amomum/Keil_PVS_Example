@echo off
if not exist "%PVS_STUDIO_PATH%CLMonitor.exe" (
    echo --------------------
    echo "PVS Studio not found! Please, check environment variable PVS_STUDIO_PATH."
    echo --------------------
    exit /B 1
)

rem Kill CLMonitor if it's already running, cause some old compilation was not complete
taskkill /F /IM CLMonitor.exe >NUL 2>NUL
"%PVS_STUDIO_PATH%CLMonitor.exe" monitor >NUL