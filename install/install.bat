REM @ECHO OFF
SETLOCAL
CALL config.bat

rd c:\etc
mklink /D c:\etc c:\k\etc

rd c:\var
mklink /D c:\var c:\k\var


md c:\etc\kube-flannel\
md c:\k\etc\kubernetes
md c:\k\etc\kubernetes\cni

CALL gen-cni-conf.bat      >C:\k\etc\kubernetes\cni\cni.conf
CALL gen-net-conf-json.bat >c:\etc\kube-flannel\net-conf.json
