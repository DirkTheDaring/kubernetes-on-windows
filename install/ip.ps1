$ipv4 = (Get-NetIPConfiguration | Where-Object {
        $_.IPv4DefaultGateway -ne $null -and
        $_.NetAdapter.Status -ne "Disconnected"
    }).IPv4Address.IPAddress
"$ipv4"
