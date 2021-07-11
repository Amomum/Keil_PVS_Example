@echo off

rem enforce this codepage so cmd errors would be readable in keil
chcp 20127 >NUL 2>NUL

rem remove old dump or it can trick us in thinking everything was okay
del "lst\pvs_dump.zip" >NUL 2>NUL
rem create new dump
"%PVS_STUDIO_PATH%CLMonitor.exe" saveDump -d "lst\pvs_dump.zip"

echo --------------------
echo PVS Studio dump saved successfully!
echo --------------------
