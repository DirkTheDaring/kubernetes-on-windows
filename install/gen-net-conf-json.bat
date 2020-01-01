@ECHO OFF
ECHO {
ECHO     "Network": "%CLUSTER_CIDR%",
ECHO     "Backend": {
ECHO         "name": "vxlan0",
ECHO         "type": "vxlan"
ECHO     }
ECHO }
