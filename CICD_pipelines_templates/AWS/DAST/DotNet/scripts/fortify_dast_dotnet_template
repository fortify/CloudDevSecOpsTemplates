#!/bin/bash
cd /home/ec2-user/

sleep 5

#ScanCentral DAST Server details
edast_server="<<eDAST API URL>>" 	# this must be ScanCentral controller DAST URL with trailing slash('/')
auth_token="<<SSC_CI_TOKEN>>"		# authentication token for SSC, this should be CI_TOKEN
edast_CI_CD_token="<<CICD_TOKEN>>"	# Scan Central DAST application wise CICD Token [SSC=>SCANCENTRAL=>DAST=>SETTING LIST]


curl_url=$edast_server'api/v2/scans/start-scan-cicd'
en_auth_token=`echo -n $auth_token | base64`



# Start eDAST Scan
curl -X POST $curl_url -H  "accept: text/plain" -H  "Authorization: FORTIFYTOKEN $en_auth_token" -H  "Content-Type: application/json-patch+json" -d "{  \"cicdToken\": \"$edast_CI_CD_token\",  \"name\": \"AWS Pipeline eDAST JAVA Scan\",  \"scannerId\": 0,  \"useAssignedScannerOnly\": true,  \"overrides\": {    \"scanPriority\": 0  }}"