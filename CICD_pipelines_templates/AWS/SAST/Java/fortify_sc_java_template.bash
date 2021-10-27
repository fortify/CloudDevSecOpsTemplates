#!/bin/bash
#pre-req installation 
#yum install unzip	#uncomment if required

#Parameters Section

#File Server to downloads the required installation files 
file_server="https://<<FILE SERVER>>/downloads" 				# this could be any file share or SSC server "http://storage.dropbox.com/"

#ScanCentral Server details
sc_server="http://<<SCANCENTRAL URL>>:8280/scancentral-ctrl/" 	# this must be ScanCentral controller URL with trailing slash('/')
auth_token="<<CI_TOKEN>>"										# authentication token for SSC, this should be CI_TOKEN
app_name="<<APP_NAME>>"											# application name from SSC
app_version="<<APP_VERSION>>"									# application version from SSC


#Parameters to configure installable
sc_install="Fortify_ScanCentral_Client_21.1.0_x64.zip" 			# installer file name, this may change based on version of installer. 
sc_client_config="client.properties"							#configuration to authenticate to scancentral controller
#End of Parameters Section

#Download required files, please ensure the URL is available
wget "$file_server/$sc_install" 
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t downloads the requierd files from server, can not continue - exit code ${e}"
	exit 100
fi

wget "$file_server/$sc_client_config" 
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t downloads the requierd files from server, can not continue - exit code ${e}"
	exit 100
fi
# End of Download

#unzip of Scan Central Client
install_dir="/opt/Fortify/scancentral"

echo 'Creating Directory for Scan Central Client'
mkdir -p $install_dir/

echo 'Unzipping...'
unzip -n -d $install_dir/ ./$sc_install
e=$?        # return code last command

if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t Unzip scancentral client"
	exit 100
fi

echo 'Configuring...'
#persmission to execute
chmod +x "$install_dir/bin/scancentral"  

cp -rf ./$sc_client_config $install_dir/Core/config/$sc_client_config

echo "Scan Starting..."
#Sending the code to scancentral
$install_dir/bin/scancentral -url $sc_server start --build-tool mvn -uptoken $auth_token -upload --application $app_name --application-version $app_version
e=$?        # return code last command

if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t Upload code to scan"
	exit 100
fi
