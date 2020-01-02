SETLOCAL ENABLEEXTENSIONS
CALL config.bat

SET SERVICE_NAME=kubelet
SET KUBECONFIG=C:\k\etc\kubernetes\admin.conf
SET NODE_NAME=%COMPUTERNAME%
REM SET CLUSTER_DNS=10.233.0.3

nssm.exe stop    %SERVICE_NAME%
nssm.exe remove  %SERVICE_NAME% confirm
del c:\k\logs\%SERVICE_NAME%.log

REM remove --windows-service ^
REM --logtostderr=false ^
REM --log-dir=C:\ProgramData\Kubernetes\logs\kubelet ^

SET CERT_DIR=C:\k\etc\pki
SET CNI_BIN_DIR=C:\k\libexec\cni
SET CNI_CONF_DIR=C:\k\etc\kubernetes\cni 

SET LOG_DIR=C:\ProgramData\Kubernetes\logs\kubelet

REM SET POD_INFRA_CONTAINER_IMAGE=mcr.microsoft.com/k8s/core/pause:1.2.0
SET FEATURE_GATES=""

nssm.exe install %SERVICE_NAME% "C:\k\sbin\kubelet.exe"
nssm.exe set %SERVICE_NAME% Description "%SERVICE_NAME% Kubernetes Service"
nssm.exe set %SERVICE_NAME% DisplayName  %SERVICE_NAME%
nssm.exe set %SERVICE_NAME% ObjectName LocalSystem
nssm.exe set %SERVICE_NAME% Start SERVICE_AUTO_START
nssm.exe set %SERVICE_NAME% Type  SERVICE_WIN32_OWN_PROCESS
nssm.exe set %SERVICE_NAME% AppEnvironmentExtra :NODE_NAME=%NODE_NAME%
nssm.exe set %SERVICE_NAME% AppEnvironmentExtra +KUBECONFIG=%KUBECONFIG%
nssm.exe set %SERVICE_NAME% AppDirectory C:\k
nssm.exe set %SERVICE_NAME% AppParameters ^
--v=6 ^
--cert-dir=%CERT_DIR% ^
--cni-bin-dir=%CNI_BIN_DIR% ^
--cni-conf-dir=%CNI_CONF_DIR% ^
--bootstrap-kubeconfig=C:\k\etc\kubernetes\bootstrap-kubelet.conf ^
--kubeconfig=C:\k\etc\kubernetes\kubelet.conf ^
--hostname-override=%NODE_NAME% ^
--pod-infra-container-image=%POD_INFRA_CONTAINER_IMAGE% ^
--enable-debugging-handlers  ^
--cgroups-per-qos=false ^
--enforce-node-allocatable="" ^
--network-plugin=cni ^
--resolv-conf="" ^
--cluster-dns="%CLUSTER_DNS%" ^
--cluster-domain=cluster.local ^
--cni-cache-dir=C:\k\var\lib\cni\cache ^
--root-dir=C:\k\var\lib\kubelet ^
--seccomp-profile-root=C:\k\var\lib\kubelet\seccomp ^
--feature-gates=%FEATURE_GATES%

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
