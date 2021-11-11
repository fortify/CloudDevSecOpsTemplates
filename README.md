# Fortify Templates for Cloud DevSecOps 
 The current software security landscape for businesses has become more complex than ever. There are more threats than ever before during a time with more complex compliance requirements and more difficult and intricate infrastructure to secure. Simply put, keeping data and applications secure is harder than ever before and organizations are having trouble keeping up.

Engineers in DevOps shops work in a self-service environment with automated Continuous Integration servers that provide self-service builds and testing. In order for success, security needs to be the same way: convenient, available when your engineers need it, seamless, and efficient.

Developers shouldn't have to wait for answers or stop work in order to get help. They need security tools that not only can they easily understand, but they can provision and run themselves. These tools need to fit seamlessly into how developers work: from Continuous Integration and Continuous Delivery, to their IDEs and pull requests. This ensures that tests and checks provide fast, clear feedback directly to the developer.

This project provides developer's a way to enable Fortify tools with cloud native development. The entire project consist of tools and automated scripts to help integrate Foritfy in different public cloud providers such as Azure DevOps, AWS and Google Cloud Platform. We have provided templates for source code repositories such as GitHub and GitLab to integrate Fortify natively.

In order to support developers and application security teams, we have created a templates which could help integrate Fortify into CI/CD pipelines faster and helps applications onboard faster.

There are majorly two(2) approaches to integrate SAST. The first one is known as **Native Integration** and the other is **NextGen integration**

![SAST integration approaches](https://github.com/rohitbaryha1/cloudDSODevKit/blob/main/web/SAST-approach.jpg?raw=true)

## Approach 1 : Native Integration
This approach is more of native support from Fortify using the SCA tool. This approach is based on the synchronous method. It gives the ability to build the quality gates so the result can be pulled while the pipeline is running. Below are some of the steps of performing an integration into the CI pipeline.

	1 Download the SCA Installer file ~1 GB
	2 Download the fortify.license file
	3 Install the SCA using installer and license file
	4 Update the Rulepacks
	5 Translate the code using SCA CLI
	6 Analyze the code using SCA CLI
	7 Upload the results to SSC via FortifyClient
	8 Apply Quality Gate via FPRUtility (Optional)

## Approach 2 : NextGen Integration (Scancentral Approach)
This approach is based on the asynchronous method. Fortify has the ScanCentral engine, which enables remote scanning very easily. Below are some of the steps of performing a NextGen integration in the CI pipeline.

	1. Download the ScanCentral Client file ~60 MB, {required Java version >=1.8}
	2. Extract the ScanCentral Client
	3. Download / Create the client.properties file
	4. Translate the code (conditional)
	5. Upload the code via ScanCentral Client to ScanCentral Controller
	6. Results will be uploaded to SSC
	7. Quality Gate (may be in next release)

Currently, these templates are technology based which means you will find .NET, JAVA technology templates to leverage as you see fit. We will be adding more technologies coming soon...


