#!powershell
#  Single purpose to create an bridge/overlay network for later use by kubernetes

# Of course i ran into this
# https://github.com/microsoft/SDN/issues/300  
# 

# Suppress Warnings as we are not responsible for the module
Import-Module "..\downloads\hns.psm1" -WarningAction silentlyContinue


if ( $args.count -eq 0 ) {
  "bridge create [l2bridge|overlay]"
  "bridge delete [l2bridge|overlay]"
  exit 0
}

$NetworkName = "External"
$AdapterName = "vEthernet (Ethernet)"
$hnsNetwork  = Get-HnsNetwork 
$network     = $hnsNetwork | ? Name -EQ $NetworkName 

if ( $args[0] -eq "create" -and $args.count -gt 1  ) {

    $NetworkMode = $args[1]
    $option = 'l2bridge', 'overlay'
    if ( ! $option.Contains($NetworkMode) ) {
        "Either l2bridge or overlay"; 
        exit 0 
    }
   
    if ( $network )  {
      "network '$NetworkName' already exists." 
      exit 0
    }

    Switch ( $NetworkMode ) {
        'l2bridge' { New-HNSNetwork -Type $NetworkMode -AddressPrefix "192.168.255.0/30" -Gateway "192.168.255.1" -Name $NetworkName -AdapterName $AdapterName -Verbose }
        'overlay'  { New-HNSNetwork -Type $NetworkMode -AddressPrefix "192.168.255.0/30" -Gateway "192.168.255.1" -Name $NetworkName -AdapterName $AdapterName -SubnetPolicies @(@{Type = "VSID"; VSID = 9999; }) -Verbose }
    }   

} elseif ( $args[0] -eq "delete" ) {
    if ( !$network )  {
        "network '$NetworkName' does not exist." 
        exit 0
    }
    $network | remove-hnsnetwork
} else {
    "invalid command."
    exit 1
}
