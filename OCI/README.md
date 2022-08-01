# OCI Template
OCI templates will help onboard applications with application security integration. The Fortify platform supports OCI DevOps Service so DevOps teams will be able to directly leverage these templates as part of pipeline automation. OCI DevOps Service supports Continuous Delivery using defined YML files during build and release. 


1.	Build_Spec.yml : This template is used to build and generate artifacts using OCI DevOps services.


## Integrating Fortify with OCI DevOps Projects
Integrating Fortify with the CI process is fairly simple pull and push switch using the templates given in the above folders.  Fortify can be integrated using the following steps:

1. Identify your Fortify solution (Fortify on-premises or Fortify on Demand)
2. Identify the type of scan you like to integrate, then go to **SAST** folder
3. Pull and merge `build_spect_<<technology>>_template.yaml` into your local repo buildspec.yaml file.
4. Set the OCI Vault variables in the templates pulled from the repo
   - Open `build_spec.yaml`
   - Change the variables as per your Fortify platform
6. Push it to your repository i.e. OCI Repo / GitHub
	
### Trigger the build, and you are done !!
