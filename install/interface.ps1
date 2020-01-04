#!powershell

if ( $args.count -eq 0 ) {
  "interface create [l2bridge|overlay]"
  "interface delete [l2bridge|overlay]"
  exit 0
}

$NetworkName = "External"
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
      "Network $NetworkName exists" 
      exit 0
    }

    Switch ( $NetworkMode ) {
        'l2bridge' { New-HNSNetwork -Type $NetworkMode -AddressPrefix "192.168.255.0/30" -Gateway "192.168.255.1" -Name $NetworkName -AdapterName "cbr0"   }
        'overlay'  { New-HNSNetwork -Type $NetworkMode -AddressPrefix "192.168.255.0/30" -Gateway "192.168.255.1" -Name $NetworkName -AdapterName "vxlan0" -SubnetPolicies @(@{Type = "VSID"; VSID = 9999; }) }
    }   
    

} elseif ( $args[0] -eq "delete" ) {

    if ( $network )  {
        "Network $NetworkName does not exist." 
        exit 0
    }
    $network | remove-hnsnetwork
}
