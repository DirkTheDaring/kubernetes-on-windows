@echo off
echo flanneld
nssm status flanneld
echo kubelet
nssm status kubelet
echo kube-proxy
nssm status kube-proxy
