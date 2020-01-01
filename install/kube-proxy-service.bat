SETLOCAL ENABLEEXTENSIONS
CALL config.bat
SET SERVICE_NAME=kube-proxy
REM SET KUBECONFIG=C:\k\etc\kubernetes\config
SET NODE_NAME=%COMPUTERNAME%

nssm.exe stop    %SERVICE_NAME%
REM sleep 1
nssm.exe remove  %SERVICE_NAME% confirm
REM del c:\k\logs\%SERVICE_NAME%.log

REM does not need --windows-service  ^
REM --logtostderr=false ^
REM --log-dir=C:\ProgramData\Kubernetes\logs\kube-proxy ^

nssm.exe install %SERVICE_NAME% "C:\k\sbin\kube-proxy.exe"
nssm.exe set %SERVICE_NAME% Description "%SERVICE_NAME% Kubernetes Service"
nssm.exe set %SERVICE_NAME% DisplayName  %SERVICE_NAME%
nssm.exe set %SERVICE_NAME% ObjectName LocalSystem
nssm.exe set %SERVICE_NAME% Start SERVICE_AUTO_START
nssm.exe set %SERVICE_NAME% Type  SERVICE_WIN32_OWN_PROCESS
nssm.exe set %SERVICE_NAME% AppEnvironmentExtra :KUBECONFIG=%KUBECONFIG%
nssm.exe set %SERVICE_NAME% AppDirectory C:\k
REM nssm.exe set %SERVICE_NAME% DependOnService :kubelet
nssm.exe set %SERVICE_NAME% AppParameters ^
--v=6 ^
--log-dir=C:\k\logs\kube-proxy ^
--hostname-override=%NODE_NAME% ^
--proxy-mode=kernelspace ^
--kubeconfig=%KUBECONFIG% ^
--network-name=vxlan0 ^
--cluster-cidr=10.233.64.0/18 ^
--feature-gates=WinOverlay=true ^
--source-vip=10.233.78.2


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
