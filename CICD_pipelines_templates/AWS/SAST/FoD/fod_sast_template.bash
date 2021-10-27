#!/bin/bash

#Parameters Section

#File Server to downloads the required installation files 
fod_uploader_url='https://github.com/fod-dev/fod-uploader-java/releases/download/v5.3.0'
fod_url=$FOD_BASEURL 												# Fortify On Demand URL 
fod_api_url='https://api.'`echo "$fod_url" | awk -F/ '{print $3}'`	# Fortify On Demand API URL


#FOD Details to Upload Code
fod_tenant=$FOD_TENANT 			# TENANT ID
fod_user_key=$FOD_USER			# FOD USER KEY
fod_pwd_secret=$FOD_PWD			# FOD PAT
fod_release_id=$FOD_RELEASE_ID	# FOD APPLICATION BASED RELEASE ID

#Parameters to configure installable
fortify_install="FodUpload.jar" 	# FOD utility file name, this may change based on version of installer. 

#Download required files, please ensure the URL is available
wget "$fod_uploader_url/$fortify_install" 
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t downloads the requierd files from server, can not continue - exit code ${e}"
	exit 100
fi

#persmission to execute
chmod +x "$fortify_install"   
# End of Download

zip -r fodsource.zip src

java -jar FodUpload.jar -ac $fod_user_key $fod_pwd_secret -rid $fod_release_id -purl $fod_url -aurl $fod_api_url -tc $fod_tenant -z fodsource.zip -ep 2 -rp 2 -pp 2 
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Fortify On Demand throws error, can not continue - exit code ${e}"
	exit 100
fi

echo "INFO: Scan Submitted Successfully..."
