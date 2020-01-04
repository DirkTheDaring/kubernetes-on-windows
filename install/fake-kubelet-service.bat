@ECHO OFF
SETLOCAL ENABLEDELAYEDEXPANSION
CALL config.bat

SET SERVICE_NAME=kubelet
nssm.exe stop    %SERVICE_NAME%
nssm.exe remove  %SERVICE_NAME% confirm

SET CERT_DIR=C:\k\etc\pki
SET LOG_DIR=C:\ProgramData\Kubernetes\logs\kubelet
SET CNI_BIN_DIR=C:\k\libexec\cni
SET CNI_CONF_DIR=C:\k\etc\kubernetes\cni 
REM SET POD_INFRA_CONTAINER_IMAGE=mcr.microsoft.com/k8s/core/pause:1.2.0
SET FEATURE_GATES=""

REM --enforce-node-allocatable="" ^
REM --resolv-conf="" ^

md C:\ProgramData\Kubernetes\logs\kubelet

SET COMMAND=^
C:\k\sbin\kubelet.exe ^
--windows-service ^
--v=6 ^
--log-dir=%LOG_DIR% ^
--cert-dir=%CERT_DIR% ^
--cni-bin-dir=%CNI_BIN_DIR% ^
--cni-conf-dir=%CNI_CONF_DIR% ^
--bootstrap-kubeconfig=/etc/kubernetes/bootstrap-kubelet.conf ^
--kubeconfig=/etc/kubernetes/kubelet.conf ^
--hostname-override=%NODE_NAME% ^
--pod-infra-container-image=%POD_INFRA_CONTAINER_IMAGE% ^
--enable-debugging-handlers ^
--cgroups-per-qos=false ^
--enforce-node-allocatable= ^
--logtostderr=false ^
--network-plugin=cni ^
--resolv-conf= ^
--cluster-dns=%CLUSTER_DNS% ^
--cluster-domain=cluster.local ^
--feature-gates=%FEATURE_GATES%
echo %COMMAND%

REM space after binpath MUST BE THERE
sc.exe create %SERVICE_NAME% binpath= "%COMMAND%"
GOTO :EOF
:LoCase
:: Subroutine to convert a variable VALUE to all lower case.
:: The argument for this subroutine is the variable NAME.
FOR %%i IN ("A=a" "B=b" "C=c" "D=d" "E=e" "F=f" "G=g" "H=h" "I=i" "J=j" "K=k" "L=l" "M=m" "N=n" "O=o" "P=p" "Q=q" "R=r" "S=s" "T=t" "U=u" "V=v" "W=w" "X=x" "Y=y" "Z=z") DO CALL SET "%1=%%%1:%%~i%%"
GOTO:EOF
