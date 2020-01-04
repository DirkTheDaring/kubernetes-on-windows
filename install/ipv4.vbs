' Win32_NetworkAdapterConfiguration
' https://docs.microsoft.com/en-us/windows/win32/cimwin32prov/win32-networkadapterconfiguration

' https://docs.microsoft.com/de-de/windows/win32/wmisdk/querying-with-wql?redirectedfrom=MSDN
' "WQL does not support queries of array datatypes."  

strMsg = ""
strComputer = "."

Set objWMIService = GetObject("winmgmts:\\" & strComputer & "\root\cimv2")
Set  IPConfigSet = objWMIService.ExecQuery ("Select IPAddress,DefaultIPGateway from Win32_NetworkAdapterConfiguration WHERE IPEnabled = 'True'")

For Each IPConfig in IPConfigSet
    If Not ( IsNull(IPConfig.IPAddress) Or IsNull(IPConfig.DefaultIPGateway)) Then
        For i = LBound(IPConfig.IPAddress) to UBound(IPConfig.IPAddress)
            If Not Instr(IPConfig.IPAddress(i), ":") > 0 Then 
                ' strMsg = strMsg & IPConfig.IPAddress(i) & vbcrlf
                strMsg = IPConfig.IPAddress(i)
                WScript.Echo  strMsg
            End If
        Next
    End If
Next
' Wscript.Echo strMsg
