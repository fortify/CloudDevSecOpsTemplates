# GCP CloudBuild Configuration
Please include below parameters for templates to run followed by adding them into Secret Manager
please refer to this URL: [https://cloud.google.com/build/docs/securing-builds/use-secrets#yaml](https://cloud.google.com/build/docs/securing-builds/use-secrets#yaml)

   - Add below parameters for ScanCentral template
  	env:
    	  - 'FORTIFY_SC_URL=${_SC_URL}' 
    	  - 'FORTIFY_CI_TOKEN=${_SC_CI_TOKEN}' 
    	  - 'APP_NAME=${_SC_APP_NAME}' 
    	  - 'APP_VERSION=${_SC_APP_VERSION}' 
    	  - 'FORTIFY_SC_CLIENT_AUTH=${_SC_CLIENT_TOKEN}' 

   - Add below parameters for Fod template
  	env:
    	  - 'FOD_BASEURL=${_FOD_URL}'
    	  - 'FOD_RELEASE_ID=${_FOD_RELEASE_ID}'
    	  - 'FOD_TENANT=${_FOD_TENANT}' 
    	  - 'FOD_USER=${_FOD_USER}'
    	  - 'FOD_PWD=${_FOD_PWD}'
	    