REM @ECHO OFF
SETLOCAL ENABLEEXTENSIONS
CALL config.bat
REM SET IPADDRESS=%1
SET IPADDRESS=192.168.178.13
SET SERVICE_NAME=flanneld

REM set path to nssm  (installed by chocolatey)
SET PATH=%PATH%;C:\ProgramData\chocolatey\lib\NSSM\tools
REM echo %PATH%

nssm.exe stop   %SERVICE_NAME%
nssm.exe remove %SERVICE_NAME% confirm
del c:\k\logs\%SERVICE_NAME%.log

REM Now setup flanneld via nssm (installed with chocolatey)
nssm.exe install %SERVICE_NAME% "C:\k\sbin\flanneld.exe"
REM nssm.exe set %SERVICE_NAME% DependOnService :kubelet
nssm.exe set %SERVICE_NAME% Description "%SERVICE_NAME% Kubernetes Service"
nssm.exe set %SERVICE_NAME% DisplayName %SERVICE_NAME%
nssm.exe set %SERVICE_NAME% ObjectName LocalSystem
nssm.exe set %SERVICE_NAME% Start SERVICE_AUTO_START
nssm.exe set %SERVICE_NAME% Type SERVICE_WIN32_OWN_PROCESS
nssm.exe set %SERVICE_NAME% AppEnvironmentExtra NODE_NAME=qemu-pc
nssm.exe set %SERVICE_NAME% AppParameters ^
-kubeconfig-file="%KUBECONFIG%" ^
-iface=%IPADDRESS% ^
-ip-masq=1 ^
-kube-subnet-mgr=1
REM logrotation HANGS on service restart if stderr and stdout are the same file.
nssm.exe set %SERVICE_NAME% AppStdout C:\k\logs\%SERVICE_NAME%-stdout.log
nssm.exe set %SERVICE_NAME% AppStderr C:\k\logs\%SERVICE_NAME%-stderr.log
nssm.exe set %SERVICE_NAME% AppStdoutCreationDisposition 4
nssm.exe set %SERVICE_NAME% AppStderrCreationDisposition 4
nssm.exe set %SERVICE_NAME% AppRotateFiles   1
nssm.exe set %SERVICE_NAME% AppRotateOnline  1
nssm.exe set %SERVICE_NAME% AppRotateSeconds 86400
nssm.exe set %SERVICE_NAME% AppRotateBytes   1048576


nssm.exe start %SERVICE_NAME%
nssm.exe dump %SERVICE_NAME% 
