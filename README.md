# Fortify Templates for Cloud DevSecOps 
Modern software delivery is synonymous with DevSecOps, meanwhile Software portfolios are in the midst of Cloud Transformation spanning cloud native, to lift-and-shift, and everything in between.  Security must keep pace with the ‘everything-as-code’ era to transition from point of friction to enablement, without sacrificing quality.  Fortify offers end-to-end application security solutions with the flexibility of testing on-premises and on-demand to scale and cover the entire software development lifecycle. Fortify integrates into your existing development toolchain seamlessly, giving you the highest quality findings and remediation advice during every stage, creating more secure software. With Fortify, you don’t need to trade quality of results for speed.

This project provides developers a collection of reference templates and implementations to enable seamless integration of Fortify tools with cloud native development. The entire project consist of tools and automated scripts to help integrate Foritfy in different public cloud providers such as Azure DevOps, AWS CodeStar and Google Cloud Platform. In order to support developers and application security teams, we have created a templates which could help integrate Fortify static application security testing (SAST) and dynamic application security testing (DAST) into CI/CD pipelines faster and helps applications onboard faster.

There are two common approaches to integrate Fortify SAST. The first one is known as **Local Integration** and the other is **Orchestrated Integration**. Fortify DAST integration utilizes the orchestrated approach and the ScanCentral DAST for shifting enterprise-grade DAST left.

## SAST Approach 1 : Local Integration
This approach utilizes a local installation of Fortify SCA to perform the SAST scan, and operates using an synchronous method. It gives the ability to build the quality gates so the result can be pulled while the pipeline is running. Below are some of the steps of performing an integration into the CI pipeline.

	1 Download the SCA Installer file ~1 GB
	2 Download the fortify.license file
	3 Install the SCA using installer and license file
	4 Update the Rulepacks
	5 Translate the code using SCA CLI
	6 Analyze the code using SCA CLI
	7 Upload the results to SSC via FortifyClient
	8 Apply Quality Gate via FPRUtility (Optional)

## SAST Approach 2 : Orchestrated Integration (ScanCentral and FoD Approach)
This approach is based on the asynchronous logic, where application code is intelligently packaged in the CI pipeline or runner. The package is uploaded to centralized scanning infrastructure of Fortify SAST scanners in ScanCentral (On-prem) or Fortify on Demand (SaaS). Below are some of the steps of performing an Orchestrated integration in the CI pipeline.

	1. Download the ScanCentral Client file, along with FoDUploader (FoD only) {required Java version >=1.8}
	2. Extract the ScanCentral Client and FoDUploader utilities
	3. Download / Create the client.properties file (ScanCentral only)
	4. Translate the code (conditional)
	5. Upload the code via ScanCentral Client to ScanCentral Controller or FoD
	6. Results will be uploaded to SSC / FoD
	7. Quality Gate via FoDUploader polling or SSC API

Currently, these templates are technology based which means you will find helpful .NET, JAVA and Python examples to provide an idea for how to invoke Fortify SCA and/or the automated packaging client for these common languages.

Additionally, Fortify on Demand users who have purchased the Software Composition Analysis subsciptions will be able to assess the open sources software in conjunction with the SAST analysis.  By simply enabling the Software Composition Analysis option in the FoD Static Scan Settings, the software bill of materials (SBOM) and list of known vulnerabilities (CVEs, etc) will be automatically produced against the code being tested.

## DAST Approach: Orchestrated Integration
Similar to the orchestrated SAST approach, integrating DAST simply requires invoking the ScanCentral DAST API once your application is deployed to a test, staging or production environment.
