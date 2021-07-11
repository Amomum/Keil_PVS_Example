@echo off
echo "##################### PVS Studio Analysis: #####################"

rem Codepage 65001 or 866 breaks PVS
rem But codepage 20127 works

chcp 20127 >NUL 2>NUL

setlocal EnableDelayedExpansion

SET PROJECT_DIR=%~dp1
SET PROJECT_NAME=%~n1

SET FILTERED_DUMP="!PROJECT_DIR!PVS-STUDIO\!PROJECT_NAME!.FilteredCompilationDump.gz"
SET OUTPUT_LOG="!PROJECT_DIR!PVS-STUDIO\!PROJECT_NAME!.plog"
SET OUTPUT_LOG_PATH="!PROJECT_DIR!\PVS-STUDIO"


"%PVS_STUDIO_PATH%\CLMonitor.exe" analyzeFromDump -d !FILTERED_DUMP! -l !OUTPUT_LOG!  -t "%~dp0\pvs_settings.xml" -c "%~dp0\ignore_warnings.pvsconfig" >NUL
"%PVS_STUDIO_PATH%\PlogConverter.exe" !OUTPUT_LOG! --renderTypes=Txt -o !OUTPUT_LOG_PATH! >NUL
more !OUTPUT_LOG_PATH!\!PROJECT_NAME!.plog.txt
