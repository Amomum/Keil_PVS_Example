@echo off
echo "##################### PVS Studio Analysis: #####################"

REM Codepage 65001 or 866 breaks PVS
REM But codepage 20127 works

chcp 20127 >NUL 2>NUL

"%PVS_STUDIO_PATH%CLMonitor.exe" analyzeFromDump -d "lst\pvs_dump.zip" -l "lst\pvs.plog"  -t "pvs\pvs_settings.xml" -c "pvs\ignore_warnings.pvsconfig" >NUL
"%PVS_STUDIO_PATH%PlogConverter.exe" "lst\pvs.plog" --renderTypes=Txt -o lst >NUL
more lst\pvs.plog.txt
