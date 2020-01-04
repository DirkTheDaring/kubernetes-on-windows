Import-Module "..\downloads\hns.psm1"

$NetworkName="vxlan0"
$hnsNetwork = Get-HnsNetwork | ? Name -EQ $NetworkName.ToLower()
$subnet = $hnsNetwork.Subnets[0].AddressPrefix
$subnet
