#!powershell
$rule10250 = Get-NetFirewallRule `
         -Name KubeletAllow10250 `
         -ErrorAction SilentlyContinue 

if ($rule10250) {
    "Removing " + $rule10250.Name
    Remove-NetFirewallRule -Name $rule10250.Name
}

$rule4789 = Get-NetFirewallRule `
         -Name OverlayTraffic4789UDP `
         -ErrorAction SilentlyContinue 

if ($rule4789) {
    "Removing " + $rule4789.Name
    Remove-NetFirewallRule -Name $rule4789.Name
}

$rule4789 = New-NetFirewallRule `
 -Name OverlayTraffic4789UDP `
 -Description "Overlay network traffic UDP" `
 -Action Allow `
 -LocalPort 4789 `
 -Enabled True `
 -DisplayName "Overlay Traffic 4789 UDP" `
 -Protocol UDP `
 -ErrorAction Stop

"Created Firewall rule for Port  4789/UDP (" + $rule4789.Name + ")"

$rule10250 = New-NetFirewallRule  `
 -Name KubeletAllow10250 `
 -Description "Kubelet Allow 10250" `
 -Action Allow `
 -LocalPort 10250 `
 -Enabled True `
 -DisplayName "KubeletAllow10250" `
 -Protocol TCP `
 -ErrorAction Stop

"Created Firewall rule for Port 10250/TCP (" + $rule10250.Name + ")"
