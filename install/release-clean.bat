@ECHO OFF
SETLOCAL
cd c:\k\logs
del /Q *.log
cd c:\k\downloads
del /Q *.*
cd c:\k\bin
del /Q kubectl.exe
del /Q kubeadm.exe
cd c:\k\sbin
del /Q kubelet.exe
del /Q kube-proxy.exe
del /Q flanneld.exe

del C:\k\etc\kubernetes\cni\cni.conf
del c:\etc\kube-flannel\net-conf.json
del C:\k\etc\kubernetes\admin.conf
del /Q c:\k\libexec\cni\*
del /Q c:\k\var\lib\kubelet\pki\*
del /Q c:\k\var\lib\kubelet\pods\*
del /Q c:\k\var\lib\dockershim\sandbox\*

rmdir /S /Q  c:\k\var\lib\kubelet\pods
