rem Expects three arguments, first - path to UV4.exe (can be obtained as #X), second - path to project (#P), third - current target name (quoted text)

chcp 20127 >NUL || exit /b

call .\..\CLMonitorDumpFilterLauncher_uVision.bat CREATE_AND_UPDATE_DUMP -keilPath %1 -projPath %2 -target %3
