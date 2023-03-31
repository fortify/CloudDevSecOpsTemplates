#!/bin/bash

# *** Configuration ***

<<<<<<< Updated upstream
#download the required tools installation script
sha256_FTI='05ac617d1e6fde80caa45fa7a1300d34cbd30a714c5276db96cc04876e7646b6'
fortify_tool_installer='https://raw.githubusercontent.com/fortify/FortifyToolsInstaller/main/FortifyToolsInstaller.sh'  # BASE UTILITY DO NOT CHANGE

fod_url=$FOD_BASEURL 												# Fortify On Demand URL 
fod_api_url='https://api.'`echo "$fod_url" | awk -F/ '{print $3}'`	# Fortify On Demand API URL
fortify_tools_dir='/root/.fortify/tools/FoDUploader/v5.2.1'			# Default installation directory
fod_util='FoDUpload.jar'											# FoD Utility alias set into FTI Script [[DO NOT CHANGE]]
=======
# Integrate Fortify On Demand Static AppSec Testing (SAST) into your AWS Codestar pipeline
# Below Parameters must be defined in buildspec.yml
	# FOD_TENANT
	# FOD_USER	
    # FOD_PWD
    # FOD_RELEASE_ID

# Local variables (modify as needed)
fod_url='https://ams.fortify.com'
fod_api_url='https://api.ams.fortify.com/'
fod_uploader_opts='-ep 2 -pp 0 -I 1 -apf'
fod_notes="Triggered by OCI DevOps"
scancentral_client_version='22.2.0'
fod_uploader_version='5.4.0'
fcli_version='v1.1.0'
fcli_sha='5553766f0f771abdf27f4c6b6d38a34825a64aaa5d72cfd03c68d7e2f43a49a0'
>>>>>>> Stashed changes

# Local variables (DO NOT MODIFY)
fortify_tools_dir="/root/.fortify/tools"	
scancentral_home=$fortify_tools_dir/ScanCentral	
fod_uploader_home=$fortify_tools_dir/foduploader
fcli_home=$fortify_tools_dir/fcli
fcli_install='fcli-linux.tgz'

# *** Execution ***

# Download Fortify CLI 
wget "https://github.com/fortify/fcli/releases/download/$fcli_version/fcli-linux.tgz"
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Failed to download Fortify CLI - exit code ${e}"
	exit 100
fi
# Verify integrity
sha256sum -c <(echo "$fcli_sha $fcli_install")
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Fortify CLI hash does not match - exit code ${e}"
	exit 100
fi

mkdir -p $fcli_home/bin
tar -xvzf "$fcli_install" -C $fcli_home/bin
export PATH=$fcli_home/bin:$fod_uploader_home/bin:$scancentral_home/bin:${PATH}

<<<<<<< Updated upstream
#Execute the shell script to download and install fortify tools
FTI_TOOLS=fu:v5.2.1 source $fti_install
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t downloads the requierd files from server, can not continue - exit code ${e}"
	exit 100
fi
=======
fcli tool sc-client install $scancentral_client_version -d $scancentral_home
fcli tool fodupload install $fod_uploader_version -d $fod_uploader_home
>>>>>>> Stashed changes

# Generate Java Package for upload to Fortify on Demand
scancentral package -bt mvn -oss -o package.zip

echo "INFO: start submitting scan"
FoDUpload -z package.zip -aurl $fod_api_url -purl $fod_url -rid ${FOD_RELEASE_ID} -tc ${FOD_TENANT} -uc ${FOD_USER} ${FOD_PWD} $fod_uploader_opts -n "$fod_notes"


echo "INFO: Scan Submitted Successfully..."
