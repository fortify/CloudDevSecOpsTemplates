#!/bin/bash
#pre-req installation 
#yum install unzip	#uncomment if required

#Parameters Section

#download the required tools installation script
sha256_FTI='2156a4926b33f5130a8101b9a809ee189cc3e51e698e1ce7516ce31f3bb09da0'
fortify_tool_installer='https://raw.githubusercontent.com/fortify/FortifyToolsInstaller/main/FortifyToolsInstaller.sh'  # BASE UTILITY DO NOT CHANGE

#ScanCentral Server details
sc_server=$FORTIFY_SC_URL										# this must be ScanCentral controller URL with trailing slash('/')
auth_token=$FORTIFY_CI_TOKEN									# authentication token for SSC, this should be CI_TOKEN
app_name=$APP_NAME												# application name from SSC
app_version=$APP_VERSION										# application version from SSC
sc_client_token=$FORTIFY_SC_CLIENT_AUTH							# ScanCentral Client authentication token

#Parameters to configure installable
fti_install='FortifyToolsInstaller.sh'
#End of Parameters Section

#Download required files, please ensure the URL is available
wget "$fortify_tool_installer" 
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t downloads the requierd files from server, can not continue - exit code ${e}"
	exit 100
fi
# End of Download
#persmission to execute
chmod +x "$fti_install"
sha256sum -c <(echo "$sha256_FTI $fti_install")
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Hashes could not be matched, can not continue - exit code ${e}"
	exit 100
fi

#Execute the shell script to download and install fortify tools
FTI_TOOLS=sc:latest SCANCENTRAL_CLIENT_AUTH_TOKEN=$sc_client_token source $fti_install
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t downloads the requierd files from server, can not continue - exit code ${e}"
	exit 100
fi

echo "Scan Starting..."
#Sending the code to scancentral
scancentral -url $sc_server start --build-tool mvn -uptoken $auth_token -upload --application $app_name --application-version $app_version
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t Submit scan to ScanCentral"
	exit 100
fi

echo "INFO: Scan Submitted Successfully..."