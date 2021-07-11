@ECHO OFF
setlocal enabledelayedexpansion

REM CLMonitorDumpFilterLauncher_uVision.bat can work in three modes: 'CREATE_AND_UPDATE_DUMP', 'ADD_COMPILED_FILE' and 'FILTER_AND_ANALYZE'.
REM Expects that CLMonitor.exe is either in system Path or env. variable PVS_STUDIO_PATH is defined and contains path to it (with a slash at the end!)
REM
REM Description of launch modes:
REM     - CREATE_AND_UPDATE_DUMP: this mode creates a compilation dump from a .bat file which will be created after building a project with the enabled 'batch creation' option.
REM                               You must run this script in this mode before using the rest modes, because that mode generates *.CompilationDump.gz file, which is needed for further work.
REM                               NOTE: do not forget to disable pre/post-build steps before .bat file generation.
REM     - ADD_COMPILED_FILE: this mode append specified file path to content of the filter file.
REM     - FILTER_AND_ANALYZE: this mode creates a new filtered dump file accourding to specified filter file. After file is created, static
REM                           analysis will be started on that dump.
REM
REM Parameters:
REM     - -keilPath - path to UV4.exe; can be automatically obtained in Keil with #X when calling a user script
REM     - -filterFile - parameter is required for 'ADD_COMPILED_FILE' and 'FILTER_AND_ANALYZE' modes. Its value is a path to filter file. 
REM     - -file - parameter is required for the 'ADD_COMPILED_FILE' mode. Its value is a path to a file which will be compiled.
REM     - -projPath - parameter is required for the 'CREATE_AND_UPDATE_DUMP' and 'FILTER_AND_ANALYZE' modes. Its value is a path to *.uvprojx project file.
REM     - -target - parameter is required for the 'CREATE_AND_UPDATE_DUMP'. Its value is the current target chosen in *.uvprojx project file.
REM     - -silent - flag which is applicable for 'ADD_COMPILED_FILE' and 'FILTER_AND_ANALYZE' modes. It makes output of the script less verbose.
REM
REM Examples of usage:
REM                   CLMonitorDumpFilterLauncher_uVision.bat CREATE_AND_UPDATE_DUMP -projPath "D:\MDK\Boards\ST\Blinky.uvprojx" -target Release
REM                   CLMonitorDumpFilterLauncher_uVision.bat ADD_COMPILED_FILE -filterFile "D:\MDK\Boards\ST\PVS-STUDIO\filesToAnalysis.txt" -file "C:\Keil_v5\ARM\PACK\ARM\CMSIS\5.0.1\CMSIS\RTOS2\RTX\Source\rtx_lib.c" [-silent]
REM                   CLMonitorDumpFilterLauncher_uVision.bat FILTER_AND_ANALYZE -projPath "D:\MDK\Boards\ST\Blinky.uvprojx" -filterFile "D:\MDK\Boards\ST\PVS-STUDIO\filesToAnalysis.txt" [-silent]

IF NOT "%LOCK%"=="" ( exit 0 )

SET SILENT_MODE=Y

SET CLMONITOR_PATH="%PVS_STUDIO_PATH%CLMonitor.exe"
SET CLMONITOR_DUMP_FILTER_PATH="%~dp0\CLMonitorDumpFilter.exe"

SET LAUNCH_MODE=%1

SHIFT

:findKeilPath
  SET curArg=%1
  SET curArg1stChar=!curArg:~0,1!
  
  IF [!curArg1stChar!] == [-] (
    IF /i [!curArg!] == [-keilPath]  (
    
      IF NOT [%2] == [] (
        SET UVISION_PATH=%~2
        SHIFT & SHIFT
      ) ELSE (
        ECHO No value specified for !curArg!
        EXIT /b
      )

    GOTO :findKeilPath
  )

IF "%LAUNCH_MODE%" == "ADD_COMPILED_FILE" (

  :addCompiledFileOptionsFlag
  SET curArg=%1
  SET curArg1stChar=!curArg:~0,1!
  
  IF [!curArg1stChar!] == [-] (
    IF /i [!curArg!] == [-filterFile]  (
    
      IF NOT [%2] == [] (
        SET FILTER_PATH=%~2
        SHIFT & SHIFT
      ) ELSE (
        ECHO No value specified for !curArg!
        EXIT /b
      )
      
    ) ELSE IF /i [!curArg!] == [-file] (
    
        IF NOT [%2] == [] (
          SET COMPILED_FILE=%~2
          SHIFT & SHIFT
        ) ELSE (
          ECHO No value specified for !curArg!
          EXIT /b
      )
        
    ) ELSE IF /i [!curArg!] == [-silent] (
    
        SET SILENT_MODE=Y
        SHIFT
        
    ) ELSE (
        ECHO "Unexpected option or flag !curArg!"
        EXIT /b
    )
    GOTO :addCompiledFileOptionsFlag
  )
  
  IF /i [!SILENT_MODE!] == [n] (
    ECHO Writing "!COMPILED_FILE!" to the file "!FILTER_PATH!".
  )
   
  !CLMONITOR_DUMP_FILTER_PATH! appendSourcesList -f "!FILTER_PATH!" -s "!COMPILED_FILE!"

  GOTO :EOF
)

IF "%LAUNCH_MODE%" == "CREATE_AND_UPDATE_DUMP" (

  :createAndUpdateDump
  SET curArg=%1
  SET curArg1stChar=!curArg:~0,1!
  
  IF [!curArg1stChar!] == [-] (
    IF /i [!curArg!] == [-projPath]  (
    
      IF NOT [%2] == [] (
        SET PROJECT_PATH=%~2
        SET PROJECT_DIR=%~dp2
        SET PROJECT_NAME=%~n2
        SET PROJECT_NAME_WITH_EXT=%~nx2
        SHIFT & SHIFT
      ) ELSE (
        ECHO No value specified for !curArg!
        EXIT /b
      )
      
    ) ELSE IF /i [!curArg!] == [-target] (
    
        IF NOT [%2] == [] (
          SET TARGET=%~2
          SHIFT & SHIFT
        ) ELSE (
          ECHO No value specified for !curArg!
          EXIT /b
      )
        
    ) ELSE (
        ECHO Unexpected option !curArg!
        EXIT /b
    )
    GOTO :createAndUpdateDump
  )
  
  SET LOCK=LOCK
  SET BAT_FILE_PATH="!PROJECT_DIR!!TARGET!.bat"
  SET TEMP_PVS_FOLDER="!PROJECT_DIR!PVS-STUDIO\"
  SET PROJECT_BACKUP_PATH="!PROJECT_DIR!PVS-STUDIO\!PROJECT_NAME_WITH_EXT!.pvs_backup"
  SET FULL_DUMP="!PROJECT_DIR!PVS-STUDIO\!PROJECT_NAME!.CompilationDump.gz"
  SET PROJECT_PATH="!PROJECT_PATH!"
  SET BUILD_PROJECT_COMMAND=!UVISION_PATH! -b !PROJECT_PATH! -j0
  
  IF NOT EXIST !TEMP_PVS_FOLDER! (
    MKDIR !TEMP_PVS_FOLDER!
  )
  
  ECHO Creating a backup of a project file
  COPY !PROJECT_PATH! !PROJECT_BACKUP_PATH! /Y

  ECHO Enabling batch creation mode in the project file: !PROJECT_PATH!
  !CLMONITOR_DUMP_FILTER_PATH! enableBatFileGeneration -p !PROJECT_PATH!
  
  IF NOT !ERRORLEVEL! == 0 (
    ECHO Couldn't enable batch creation mode
    GOTO :EOF
  )

  ECHO Building project
  @ECHO ON
  %BUILD_PROJECT_COMMAND%
  @ECHO OFF

  ECHO Restoring project file from backup
  COPY !PROJECT_BACKUP_PATH! !PROJECT_PATH! /Y

  IF !ERRORLEVEL! == 0 (
    ECHO Deleting a backup of project file
    DEL !PROJECT_BACKUP_PATH!
  ) ELSE (
    ECHO Couldn't restore the project file from backup
  )

  ECHO Creating dump file: !FULL_DUMP!
  !CLMONITOR_DUMP_FILTER_PATH! filterDump -c !BAT_FILE_PATH! -d !FULL_DUMP!
  
  ECHO Deleting target batch file
  DEL /f !BAT_FILE_PATH!
  
  SET LOCK=
  GOTO :EOF
)

IF "%LAUNCH_MODE%" == "FILTER_AND_ANALYZE" (
  
  :filterAndAnalyze
  SET curArg=%1
  SET curArg1stChar=!curArg:~0,1!
  
  IF [!curArg1stChar!] == [-] (
    IF /i [!curArg!] == [-projPath]  (
    
      IF NOT [%2] == [] (
        SET PROJECT_PATH=%~2
        SET PROJECT_DIR=%~dp2
        SET PROJECT_NAME=%~n2
        SET PROJECT_NAME_WITH_EXT=%~nx2
        SHIFT & SHIFT
      ) ELSE (
        ECHO No value specified for !curArg!
        EXIT /b
      )
      
    ) ELSE IF /i [!curArg!] == [-filterFile] (
    
        IF NOT [%2] == [] (
          SET FILTER_PATH=%2
          SHIFT & SHIFT
        ) ELSE (
          ECHO No value specified for !curArg!
          EXIT /b
        )
        
    ) ELSE IF /i [!curArg!] == [-silent] (
        SET SILENT_MODE=Y
        SHIFT
    ) ELSE (
        ECHO Unexpected option or flag !curArg!
        EXIT /b
    )
    GOTO :filterAndAnalyze
  )
  
  SET TEMP_PVS_FOLDER="!PROJECT_DIR!PVS-STUDIO\"
  SET PROJECT_BACKUP_PATH="!PROJECT_DIR!PVS-STUDIO\!PROJECT_NAME_WITH_EXT!.pvs_backup"
  SET FULL_DUMP="!PROJECT_DIR!PVS-STUDIO\!PROJECT_NAME!.CompilationDump.gz"
  SET FILTERED_DUMP="!PROJECT_DIR!PVS-STUDIO\!PROJECT_NAME!.FilteredCompilationDump.gz"
  SET OUTPUT_LOG="!PROJECT_DIR!PVS-STUDIO\!PROJECT_NAME!.plog"

  ECHO Creating filtered dump: !FILTERED_DUMP!
  !CLMONITOR_DUMP_FILTER_PATH! filterDump -c !FULL_DUMP! -d !FILTERED_DUMP! -f !FILTER_PATH!

  REM Analysis itself will be performed by a separate script
  
  )
)
