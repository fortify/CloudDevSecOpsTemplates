#!/bin/bash

#Parameters Section

#download the required tools installation script
sha256_FTI='2156a4926b33f5130a8101b9a809ee189cc3e51e698e1ce7516ce31f3bb09da0'
fortify_tool_installer='https://raw.githubusercontent.com/fortify/FortifyToolsInstaller/main/FortifyToolsInstaller.sh'  # BASE UTILITY DO NOT CHANGE

fod_url=$FOD_BASEURL 												# Fortify On Demand URL 
fod_api_url='https://api.'`echo "$fod_url" | awk -F/ '{print $3}'`	# Fortify On Demand API URL
fortify_tools_dir='/root/.fortify/tools/FoDUploader/v5.3.1'			# Default installation directory
fod_util='FoDUpload.jar'											# FoD Utility alias set into FTI Script [[DO NOT CHANGE]]

#FOD Details to Upload Code
fod_tenant=$FOD_TENANT 			# TENANT ID
fod_user_key=$FOD_USER			# FOD USER KEY
fod_pwd_secret=$FOD_PWD			# FOD PAT
fod_release_id=$FOD_RELEASE_ID	# FOD APPLICATION BASED RELEASE ID

#Parameters to configure installable
fti_install='FortifyToolsInstaller.sh'

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

FTI_TOOLS=sc:latest source $fti_install
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t downloads the requierd files from server, can not continue - exit code ${e}"
	exit 100
fi

#Execute the shell script to download and install fortify tools
FTI_TOOLS=fu:v5.3.1 source $fti_install
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t downloads the requierd files from server, can not continue - exit code ${e}"
	exit 100
fi

#Generate Java Package to upload in FoD
scancentral package -o sourcecode.zip --build-tool mvn

java -jar $fortify_tools_dir/$fod_util -ac $fod_user_key $fod_pwd_secret -rid $fod_release_id -purl $fod_url -aurl $fod_api_url -tc $fod_tenant -z sourcecode.zip -ep 2 -rp 2 -pp 2 
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Fortify On Demand throws error, can not continue - exit code ${e}"
	exit 100
fi

echo "INFO: Scan Submitted Successfully..."
