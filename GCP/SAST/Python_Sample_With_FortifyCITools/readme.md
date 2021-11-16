# GCP CloudBuild Configuration
Fortify can be integrated using Docker image for Fortify CI tools. Please ensure to leverage enviornment variables from the secret manager.

##Add/Update below parameters for ScanCentral template

	env:
	    - 'FORTIFY_SC_URL=${_SC_URL}'
	    - 'FORTIFY_CI_TOKEN=${_SC_CI_TOKEN}'
	    - 'APP_NAME=${_SC_APP_NAME}'
	    - 'APP_VERSION=${_SC_APP_VERSION}'
	    