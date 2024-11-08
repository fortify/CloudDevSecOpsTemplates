# GCP CloudBuild Configuration
Please include below parameters for templates to run followed by adding them into Secret Manager
please refer to this URL: [https://cloud.google.com/build/docs/securing-builds/use-secrets#yaml](https://cloud.google.com/build/docs/securing-builds/use-secrets#yaml)

env:

   Add below parameters in Cloud Build Secrets for ScanCentral template  
   
	**INTEGRATE FORTIFY SCANCENTRAL**
		````
		FCLI_DEFAULT_SC_SAST_CLIENT_AUTH_TOKEN
		FCLI_DEFAULT_SSC_USER
		FCLI_DEFAULT_SSC_PASSWORD
		FCLI_DEFAULT_SSC_CI_TOKEN
		FCLI_DEFAULT_SSC_URL
		SSC_APP_VERSION_ID
		````

   Add below parameters in Cloud Build Secrets for FoD template	
   
	**INTEGRATE FORTIFY ON DEMAND**
		````
        FCLI_DEFAULT_FOD_URL
		FCLI_DEFAULT_FOD_USER
		FCLI_DEFAULT_FOD_PASSWORD
		FCLI_DEFAULT_FOD_TENANT
	 	FOD_RELEASE_ID
		````   