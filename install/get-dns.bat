@ECHO OFF
SETLOCAL
CALL config.bat
REM kubectl get services  -o json -n kube-system | jq -r   ".items[]|select(.metadata.name==\"coredns\")|.spec.clusterIP"
REM get the ip from  the service that contains "dns" in its name
kubectl get services  -o json -n kube-system | jq -r   ".items[]|select(.metadata.name|contains(\"dns\"))|.spec.clusterIP"
