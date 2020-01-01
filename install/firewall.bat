@ECHO OFF
SETLOCAL 

REM Get Filename of current bat file
SET BATFILENAME=%~F0

REM cut off .bat extension
SET PREFIX=%BATFILENAME:~0,-4%
REM create script name with extension .ps1
SET SCRIPTNAME=%PREFIX%.ps1

powershell -ExecutionPolicy Bypass %SCRIPTNAME% %*
