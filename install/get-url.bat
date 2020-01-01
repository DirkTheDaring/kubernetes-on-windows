@ECHO OFF 
SETLOCAL
CALL config.bat
kubectl get endpoints -o json --all-namespaces |jq --raw-output   ".items[]|select(.metadata.name==\"kubernetes\") | [ .subsets[].ports[].name,\"://\",.subsets[].addresses[].ip,\":\",(.subsets[].ports[].port|tostring) ]|join(\"\")"
