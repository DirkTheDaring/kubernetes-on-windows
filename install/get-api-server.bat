@ECHO OFF 
SETLOCAL
CALL config.bat
kubectl get endpoints -o json --all-namespaces |jq --raw-output   ".items[]|select(.metadata.name==\"kubernetes\") | [ .subsets[].addresses[].ip,\":\",(.subsets[].ports[].port|tostring) ]|join(\"\")"
