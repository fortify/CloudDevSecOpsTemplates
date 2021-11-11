# AWS BuildSpec Configuration
Please include below parameters for templates to run followed by adding them into parameter store

   - Add below parameters for ScanCentral template
	env:
  	  variables:
    	    APP_NAME: "Saturn"
            APP_VERSION: "1.0"
  	  parameter-store:
    	    FORTIFY_SC_URL: "/fortify/sc_url"
    	    FORTIFY_CI_TOKEN: "/fortify/ci_token" 
    	    FORTIFY_SC_CLIENT_AUTH: "/fortify/sc_client_auth"

   - Add below parameters for Fod template
	env:
  	  variables:
            FOD_RELEASE_ID: "XXXXX"
  	  parameter-store:
    	    FOD_BASEURL: "/fod/baseurl"
    	    FOD_TENANT: "/fod/tenant"
    	    FOD_USER: "/fod/user" 
    	    FOD_PWD: "/fod/pwd"
	    