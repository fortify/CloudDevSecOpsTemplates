# GCP CloudBuild Configuration
Fortify can be initiate DAST scan using ScanCentral DAST. Please ensure to leverage enviornment variables from the secret manager

##Add below parameters for ScanCentral template

	env:
	````
	   FCLI_DEFAULT_SC_SAST_CLIENT_AUTH_TOKEN
	   FCLI_DEFAULT_SSC_USER
	   FCLI_DEFAULT_SSC_PASSWORD
	   FCLI_DEFAULT_SSC_CI_TOKEN
	   FCLI_DEFAULT_SSC_URL
	   SSC_APP_VERSION_ID
	````