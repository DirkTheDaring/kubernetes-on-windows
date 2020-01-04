@ECHO OFF
SETLOCAL 

:: Use absolute path and Replace .bat with .ps1 extension
:: %~DP0 Absolute path to script directory
:: %~N0  name of script with out extension (e.g. bat is cut off)

powershell -ExecutionPolicy Bypass "%~DP0%~N0.ps1" %*
