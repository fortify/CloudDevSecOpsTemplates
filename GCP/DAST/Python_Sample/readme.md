# GCP CloudBuild Configuration
Fortify can be initiate DAST scan using ScanCentral DAST. Please ensure to leverage enviornment variables from the 

##Add below parameters for ScanCentral template

	env:
	    - 'FORTIFY_DAST_API=${_EDAST_API_URL_}'
	    - 'FORTIFY_CI_TOKEN=${_SSC_CI_TOKEN_}'
	    - 'EDAST_CI_CD_TOKEN=${_EDAST_CICD_TOKEN}'
