
<!-- START-INCLUDE:repo-usage.md -->

# Fortify Templates for Cloud DevSecOps  - Usage Instructions

There are two common approaches to integrate Fortify SAST. The first one is known as **Orchestrated Integration** and the other is **Local Integration**. Fortify DAST integration utilizes the orchestrated approach and the ScanCentral DAST for shifting enterprise-grade DAST left.

## SAST Approach 1 : Orchestrated Integration (ScanCentral and FoD Approach)
This approach is based on the asynchronous logic, where application code is intelligently packaged in the CI pipeline or runner. The package is uploaded to centralized scanning infrastructure of Fortify SAST scanners in ScanCentral (On-prem) or Fortify on Demand (SaaS). Below are some of the steps of performing an Orchestrated integration in the CI pipeline.

	1. Use [Foritfy CLI](https://github.com/fortify/fcli/)
	2. Install the ScanCentral Client and FoDUploader utilities
	3. Setup Parameters to authenticate Fortify CLI with ScanCentral and FoD
	4. Translate the code (conditional)
	5. Upload the code via ScanCentral Client to ScanCentral Controller or FoD
	6. Results will be uploaded to SSC / FoD
	7. Security Gate via Fortify CLI utility

Currently, these templates are technology based which means you will find helpful .NET, JAVA and Python examples to provide an idea for how to invoke Fortify SCA and/or the automated packaging client for these common languages.

## SAST Approach 2 : Local Integration
This approach utilizes a local installation of Fortify SCA to perform the SAST scan, and operates using an synchronous method. It gives the ability to build the security gates so the result can be pulled while the pipeline is running. Below are some of the steps of performing an integration into the CI pipeline.

	1 Download the SCA Installer file ~1 GB
	2 Download the fortify.license file
	3 Install the SCA using installer and license file
	4 Update the Rulepacks
	5 Translate the code using SCA CLI
	6 Analyze the code using SCA CLI
	7 Upload the results to SSC via FortifyClient
	8 Apply Security Gate via FPRUtility (Optional)



## DAST Approach: Orchestrated Integration
Similar to the orchestrated SAST approach, integrating DAST simply requires invoking the ScanCentral DAST API once your application is deployed to a test, staging or production environment.

<!-- END-INCLUDE:repo-usage.md -->


---

*This document was auto-generated from USAGE.template.md; do not edit by hand*
