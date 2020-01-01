@ECHO OFF
CALL config.bat
ECHO {
ECHO     "cniVersion": "0.2.0",
ECHO     "name": "vxlan0",
ECHO     "type": "flannel",
ECHO     "capabilities": {
ECHO         "dns": true
ECHO     },
ECHO     "delegate": {
ECHO         "type": "win-overlay",
ECHO         "Policies": [
ECHO             {
ECHO                 "Name": "EndpointPolicy",
ECHO                 "Value": {
ECHO                     "Type": "OutBoundNAT",
ECHO                     "ExceptionList": [
ECHO                         "%CLUSTER_CIDR%",
ECHO                         "%SERVICE_CIDR%"
ECHO                     ]
ECHO                 }
ECHO             },
ECHO             {
ECHO                 "Name": "EndpointPolicy",
ECHO                 "Value": {
ECHO                     "Type": "ROUTE",
ECHO                     "DestinationPrefix": "%SERVICE_CIDR%",
ECHO                     "NeedEncap": true
ECHO                 }
ECHO             }
ECHO         ]
ECHO     }
ECHO }
