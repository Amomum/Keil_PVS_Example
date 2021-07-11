@echo off

rem Expects two arguments, first - path to UV4.exe (can be obtained as #X), second - path to current file (#E)

rem Codepage 65001 or 866 breaks PVS
rem But codepage 20127 works
chcp 20127 >NUL 2>NUL

if not exist ".\PVS-STUDIO\" (
  echo "---------------------------"
  echo "Please launch 'Before Build' script first (at least once); Go to Project->Options and enable it; change 'Target 1' to your target name"
  echo "You can disable it after one full rebuild"
  echo -
  exit /B 1
)

call .\..\CLMonitorDumpFilterLauncher_uVision.bat ADD_COMPILED_FILE -keilPath %1 -filterFile ".\PVS-STUDIO\filesToAnalyse.txt" -file %2 