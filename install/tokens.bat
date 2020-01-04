@ECHO OFF
SETLOCAL
CALL config.bat

kubeadm token create --print-join-command --enforce-node-allocatable
REM --cgroups-per-qos=false
