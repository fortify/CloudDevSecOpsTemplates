# CloudDSODeveloperKit
 The current digital security landscape for businesses can accurately be described in one word: complicated. More numerous and advanced threats, more nebulous and complex compliance requirements, more difficult and intricate infrastructure to secure. Simply put, keeping data, workloads, and users secure is more than a full-time job—and organizations are having trouble keeping up.

Engineers in DevOps shops work in a self-service environment. Automated Continuous Integration servers provide self-service builds and testing. Security needs to be made available to the team in the same way: convenient, available when your engineers need it, seamless, and efficient.

Don’t get in their way. Don’t make developers wait for answers or stop work in order to get help. Give them security tools that they can use and understand and that they can provision and run themselves. And ensure that those tools fit into how they work: into Continuous Integration and Continuous Delivery, into their IDEs as they enter code, into code pull requests. In other words, ensure that tests and checks provide fast, clear feedback.

This project is an attempt to provide developer's a way to enable fortify with native cloud development. The entire project consist of tools and automated scripts to help integrate Foritfy in different public cloud providers such as Azure DevOps, AWS and Google Cloud Platform. I have also provide templates for source code repository such as GitHub and GitLab to integrate fortify natively.

In order to support developers and application security teams, I have created a templates which could help integrate Fortify in CI/CD pipeline faster and helps applications onboarding quicker.

There are majorly two(2) approaches to integrate SAST, the first one is known as **Native Integration** and the other is **NextGen integration**

![SAST integration approaches](https://github.com/rohitbaryha1/cloudDSODevKit/blob/main/web/SAST-approach.jpg?raw=true)

## Approach 1 : Native Integration
This approach is more of native support from Fortify using SCA tool. This approach is basd on synchronous method. This approach gives ability to build the quality gates since the result can be pulled while pipeline is running. Below are some of the steps of performing a integration in CI pipeline.

	1 Download the SCA Installer file ~1 GB
	2 Download the fortify.license file
	3 Install the SCA using installer and license file
	4 Update the Rulepacks
	5 Translate the code using SCA CLI
	6 Analyze the code using SCA CLI
	7 Upload the results to SSC via FortifyClient
	8 Apply Quality Gate via FPRUtility (Optional)

## Approach 2 : NextGen Integration (Scancentral Approach)
This approach is based on asynchronous method. Fortify has a scancentral engine which enable remote scanning quite easily. below are some of the steps of performing a NextGen integration in CI pipeline.

	1. Download the ScanCentral Client file ~60 MB, {required Java version >=1.8}
	2. Extract the ScanCentral Client
	3. Download / Create the client.properties file
	4. Translate the code (conditional)
	5. Upload the code via ScanCentral Client to ScanCentral Controller
	6. Results will be uploaded to SSC
	7. Quality Gate (may be in next release)

Currently,  these templates are technology basis which means you will find .NET, JAVA technology templates to leverage as you see fit. there will be more technologies coming soon...


