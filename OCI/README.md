# OCI Template
OCI templates will help onboard applications with application security integration. Fortify platform support OCI DevOps projects so DevOps teams will be able to directly leverage these templates as part of pipeline automation. OCI DevOps projects service supports Continious Delivery using their defined YML files during build and release. 


1.	Build_Spec.yml : This template used to build and generate artifacts using OCI managed services. It depicts the CI process in DevSecOps framework.


## Integrating Fortify with OCI DevOps Projects
Integrating Fortify with CI process is fairly simple pull and push switch using the templates given in the above folders.  Fortify can be integrated using below steps.

1. Identify your Fortify solution (Fortify on-premises or Fortify on Demand)
2. Identify the type of scan you like to integrate, then go to **SAST** folder
3. Pull/copy `build_spect.yaml` into your local repo
4. Set the OCI Vault variables in the templates pull from the repo
   - Open `build_spec.yaml`
   - change the variables as per your Fortify platform
6. Push it to your repository i.e. OCI Repo / GitHub
	
### Trigger the build, and you are done !!
