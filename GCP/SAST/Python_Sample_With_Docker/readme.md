# GCP CloudBuild Configuration
Fortify can be integrated using Docker image for Fortify CI tools. Please ensure to leverage enviornment variables from the 

##Add below parameters for ScanCentral template

	env:
    	  - 'FORTIFY_SC_URL=${_SC_URL}' 
    	  - 'FORTIFY_CI_TOKEN=${_SC_CI_TOKEN}' 
    	  - 'APP_NAME=${_SC_APP_NAME}' 
    	  - 'APP_VERSION=${_SC_APP_VERSION}' 
    	  - 'FORTIFY_SC_CLIENT_AUTH=${_SC_CLIENT_TOKEN}' 

##Add below parameters for Fod template

	env:
    	  - 'FOD_BASEURL=${_FOD_URL}'
    	  - 'FOD_RELEASE_ID=${_FOD_RELEASE_ID}'
    	  - 'FOD_TENANT=${_FOD_TENANT}' 
    	  - 'FOD_USER=${_FOD_USER}'
    	  - 'FOD_PWD=${_FOD_PWD}'
	    