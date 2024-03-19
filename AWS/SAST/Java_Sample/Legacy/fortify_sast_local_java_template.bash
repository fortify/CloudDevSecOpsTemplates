#!/bin/bash

#Parameters Section

#File Server to downloads the required installation files 
file_server="https://<<FILE SERVER>>/downloads" 	# this could be any file share or SSC server "http://storage.dropbox.com/"

#SSC Server to Upload results
ssc_server="http://SSCSERVER:PORT/ssc/" 			# this could be SSC server address with trailing slash('/')
auth_token="<<CI_TOKEN>>"							# authentication token for SSC, this should be CI_TOKEN
app_version_id="<<APP_VERSION_ID>>"					# application version id from SSC
pull_result_from_ssc=true

#Parameters to configure installable
fortify_install="Fortify_SCA_and_Apps_21.1.1_linux_x64.run" # installer file name, this may change based on version of installer. 
fortify_license="fortify.license" 					#SAST license file name

#Parameter for AWS S3 bucket
s3_storage_required=true
s3_bucket="<<S3 BUCKET URL>>" 					 #S3 bucket URL i.e. s3://aws-codestar-us-east-1********
#End of Parameters Section

#Download required files, please ensure the URL is available
wget "$file_server/$fortify_install" 
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t downloads the requierd files from server, can not continue - exit code ${e}"
	exit 100
fi

wget "$file_server/$fortify_license" 
e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Can;t downloads the requierd files from server, can not continue - exit code ${e}"
	exit 100
fi

#persmission to execute
chmod +x "$fortify_install"   
# End of Download

#Installation of SCA
install_dir="/opt/Fortify/Fortify_SCA_and_Apps_21.1.1"
./$fortify_install --fortify_license_path ./$fortify_license --mode unattended --installdir $install_dir/

e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: Fortify Installation failed, can not continue - exit code ${e}"
	exit 100
fi

$install_dir/bin/fortifyupdate
echo "Scan Starting..."
#Translation and analyzing of Code
$install_dir/bin/sourceanalyzer -b aws-java-build -clean

echo "Translating..."
#include more file types as required 
$install_dir/bin/sourceanalyzer -b aws-java-build -source 11 -cp "./**/*.jar" "./**/*.java" "./**/*.js" "./**/*.jsp" "./**/*.html" "./**/*.properties" "./**/*.xml"

echo "Scan Started..."
#Generate SAST report
$install_dir/bin/sourceanalyzer -b aws-java-build -scan -f aws-sast-report.fpr

echo "Uploading results..."
#Upload scan to SSC
echo "$install_dir/bin/fortifyclient -url $ssc_server -authtoken $auth_token -applicationVersionID $app_version_id uploadFPR -file aws-sast-report.fpr"
$install_dir/bin/fortifyclient -url $ssc_server -authtoken $auth_token -applicationVersionID $app_version_id uploadFPR -file aws-sast-report.fpr

e=$?        # return code last command
if [ "${e}" -ne "0" ]; then
	echo "ERROR: SSC Upload failed, can not continue - exit code ${e}"
	exit 100
fi

if [ "$pull_result_from_ssc" = true ] ; then
	echo "INFO: Trying to connect to SSC Server"
	sleep 5
	curl_cmd=$ssc_server'api/v1/projectVersions/'$app_version_id'/issues?start=0&filter=ISSUE%5B11111111-1111-1111-1111-111111111151%5D:SCA&orderby=-friority'
	en_auth_token=`echo -n $auth_token | base64`
	curl -k -X GET $curl_cmd -H "accept: application/json" -H "Authorization: FortifyToken $en_auth_token" -o aws-sast-report-ssc.json

	if [ "$s3_storage_required" = true ] ; then
		echo "Uploading SSC results to s3 bucket..."
		#Upload scan to S3
		aws s3 cp aws-sast-report-ssc.json $s3_bucket/aws-sast-report-ssc.json --acl public-read
	fi	
fi

if [ "$s3_storage_required" = true ] ; then
	echo "Uploading results to s3 bucket..."
	#Upload scan to S3
	aws s3 cp aws-sast-report.fpr $s3_bucket/aws-sast-report.fpr --acl public-read
fi
