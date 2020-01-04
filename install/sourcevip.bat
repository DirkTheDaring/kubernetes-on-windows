@ECHO OFF
SETLOCAL 

:: Query SourceVIP

:: $hnsNetwork = Get-HnsNetwork | ? Name -EQ $NetworkName.ToLower()
:: $subnet = $hnsNetwork.Subnets[0].AddressPrefix

REM awkward dos version of IPADRESS=$(ipv4) in bash
FOR /F "tokens=*" %%a IN ( 'subnet.bat' ) DO ( 
  SET SUBNET=%%a
) 

SET DATADIR=/var/lib/cni/networks
SET FILENAME=source-vip-request.json

ECHO {"cniVersion": "0.2.0", "name": "vxlan0", "ipam":{"type":"host-local","ranges":[[{"subnet":"%SUBNET%"}]],"dataDir":"%DATADIR%"}} >%FILENAME%
SET CNI_COMMAND=ADD
SET CNI_CONTAINERID=dummy
SET CNI_NETNS=dummy
SET CNI_IFNAME=dummy
SET CNI_PATH=C:\k\libexec\cni

:: type  %FILENAME%
type  %FILENAME% | %CNI_PATH%\host-local.exe
