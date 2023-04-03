#!/bin/bash
# Integrate Fortify ScanCentral Static AppSec Testing (SAST) into your AWS Codestar pipeline

# *** Configuration ***
# The following variables must be defined in buildspect.yml
export FCLI_DEFAULT_SC_SAST_CLIENT_AUTH_TOKEN=$FCLI_DEFAULT_SC_SAST_CLIENT_AUTH_TOKEN
export FCLI_DEFAULT_SSC_USER=$FCLI_DEFAULT_SSC_USER
export FCLI_DEFAULT_SSC_PASSWORD=$FCLI_DEFAULT_SSC_PASSWORD
export FCLI_DEFAULT_SSC_CI_TOKEN=$FCLI_DEFAULT_SSC_CI_TOKEN
export FCLI_DEFAULT_SSC_URL=$FCLI_DEFAULT_SSC_URL
ssc_app_version_id=$SSC_APP_VERSION_ID

# Local variables (modify as needed)
scancentral_client_version='22.2.0'
fcli_version='v1.1.0'
fcli_sha='5553766f0f771abdf27f4c6b6d38a34825a64aaa5d72cfd03c68d7e2f43a49a0'

# Local variables (DO NOT MODIFY)
fortify_tools_dir="/root/.fortify/tools"	
scancentral_home=$fortify_tools_dir/ScanCentral	
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
export PATH=$fcli_home/bin:$scancentral_home/bin:${PATH}

fcli tool sc-client install $scancentral_client_version -d $scancentral_home

echo Setting connection with Fortify Platform
# USE --INSECURE WHEN YOUR SSL CERTIFICATES ARE SELF GENERATED/UNTRUSTED
fcli ssc session login
fcli sc-sast session login

scancentral package -bt mvn -o package.zip

fcli sc-sast scan start --appversion=$ssc_app_version_id --upload --sensor-version=$scancentral_client_version --package-file=package.zip --store='?'
echo "INFO: Scan Submitted Successfully..."

fcli sc-sast scan wait-for '?' --interval=30s
fcli ssc appversion-vuln count --appversion=$SSC_APP_VERSION_ID

echo Terminating connection with Fortify Platform
fcli sc-sast session logout
fcli ssc session logout