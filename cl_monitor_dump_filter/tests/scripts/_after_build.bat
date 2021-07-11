@echo off

rem Expects two arguments, first - path to UV4.exe (can be obtained as #X), second - path to project (#P)

rem Codepage 65001 or 866 breaks PVS
rem But codepage 20127 works

chcp 20127 >NUL 2>NUL

call .\..\check_project.bat
call .\..\CLMonitorDumpFilterLauncher_uVision.bat FILTER_AND_ANALYZE -keilPath %1 -projPath %2 -filterFile ".\PVS-STUDIO\filesToAnalyse.txt" 
call .\..\view_pvs_log.bat %2 

