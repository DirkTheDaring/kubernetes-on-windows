@ECHO OFF
SETLOCAL
nssm stop kubelet

CALL config.bat
echo %PATH%
REM awkward dos version of URL=$(get-api-server) in bash
FOR /F "tokens=*" %%a IN ( 'get-api-server.bat' ) DO ( 
  SET API_SERVER=%%a
) 
REM echo "API_SERVER=%API_SERVER%"
SET NODE_NAME=%COMPUTERNAME%
SET NODE_NAME=qemu-pc
REM echo "%NODE_NAME%"


md C:\etc\kubernetes
md C:\etc\kubernetes\ssl

CALL restart-clean.bat
kubeadm join phase preflight --v=6 --node-name=%NODE_NAME%  "%API_SERVER%" --token %KUBERNETES_CONTROLPLANE_KUBEADMTOKEN% --discovery-token-ca-cert-hash %KUBERNETES_CONTROLPLANE_KUBEADMCAHASH% --ignore-preflight-errors all
echo *** control-plan-prepare******************************************
kubeadm join phase control-plane-prepare --v=6  all --node-name=%NODE_NAME%  "%API_SERVER%" --token %KUBERNETES_CONTROLPLANE_KUBEADMTOKEN% --discovery-token-ca-cert-hash %KUBERNETES_CONTROLPLANE_KUBEADMCAHASH% 
echo *** kubelet-start ******************************************
kubeadm join phase kubelet-start --v=10  --node-name=%NODE_NAME%  "%API_SERVER%" --token %KUBERNETES_CONTROLPLANE_KUBEADMTOKEN% --discovery-token-ca-cert-hash %KUBERNETES_CONTROLPLANE_KUBEADMCAHASH% 
echo *** control-plane-join ******************************************
kubeadm join phase control-plane-join --v=6 all
echo *********************************************

