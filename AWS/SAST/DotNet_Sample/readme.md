# AWS BuildSpec Configuration
Please include below parameters for templates to run followed by adding them into parameter store

env:

  parameter-store:
  
   - Add below parameters in parameter-store for Fod template  
   
		**INTEGRATE FORTIFY ON DEMAND**
		````
		FOD_RELEASE_ID: "/fod/releaseid"
		FOD_TENANT: "/fod/tenant"
		FOD_USER: "/fod/user"
		FOD_PAT: "/fod/pat"  
		````
   - Add below parameters in parameter-store for ScanCentral template	
   
		**INTEGRATE FORTIFY SCANCENTRAL**
		````
        FCLI_DEFAULT_SC_SAST_CLIENT_AUTH_TOKEN: "/fortify/client_auth_token"
        FCLI_DEFAULT_SSC_USER: "/fortify/ssc_user"
        FCLI_DEFAULT_SSC_PASSWORD: "/fortify/ssc_password"
        FCLI_DEFAULT_SSC_CI_TOKEN: "/fortify/ci_token"
        FCLI_DEFAULT_SSC_URL: "/fortify/ssc_url"
        SSC_APP_VERSION_ID: "/fortify/ssc_app_versionid"
		````