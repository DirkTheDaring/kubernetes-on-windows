@ECHO OFF
SETLOCAL EnableDelayedExpansion
CALL config.bat

md ..\downloads
cd ..\downloads

curl -LO -C - "%KUBERNETES_SOURCE_URL%"
curl -LO -C - "%CNI_SOURCE_URL0%"
curl -LO -C - "%CNI_PLUGINS_URL%"

REM poor mans "basename $KUBERNETES_SOURCE_URL"
for %%a in ("%KUBERNETES_SOURCE_URL%") do (
   set "urlPath=!url:%%~NXa=!"
   set "FILENAME=%%~NXa"
)
REM echo %FILENAME%
tar xvzf "%FILENAME%" --strip-components=3 kubernetes/node/bin/

md ..\sbin
md ..\bin

copy flanneld.exe ..\sbin
move kubelet.exe ..\sbin
move kube-proxy.exe ..\sbin

move kubectl.exe ..\bin
move kubeadm.exe ..\bin

for %%a in ("%CNI_PLUGINS_URL%") do (
   set "urlPath=!url:%%~NXa=!"
   set "FILENAME=%%~NXa"
)
REM echo %FILENAME%
tar xvzf "%FILENAME%"

md ..\libexec\cni
move flannel.exe     ..\libexec\cni
move win-overlay.exe ..\libexec\cni
move win-bridge.exe  ..\libexec\cni
move host-local.exe  ..\libexec\cni
