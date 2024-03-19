# Fortify enabled AWS Pipeline
Pipeline using AWS cloud native services and Fortify platform.

This pipeline uses AWS DevOps tools CodeBuild, AWS CodeCommit, and AWS CodePipeline along with other AWS services.  It is highly recommended to fully test the pipeline in lower environments and adjust as needed before deploying to production.

## Build and Test: 

AWS Buildspec and property files for Fortify scanning:
* fortify-sast-fod-buildspec.yml: buildspec file to perform SCA analysis using Fortify On Demand.

## Lambda files:
AWS lambda is used to parse the security scanning results and post them to AWS Security Hub
* fortify_sast_fod_aws_hub_parser.py: to parse the scanning results and extract the vulnerability details to post to AWS Security Hub in ASFF format (AWS Security Finding Format).

## CloudFormation for Pipeline:

* fortify_sast_fod_cloudformation_template.yml: CloudFormation template to deploy AWS CI Pipeline 

## Deploying the template:
Download the CloudFormation template and IWAJava code from GitHub repo.

1.	Log in to your AWS account if you have not done so already. 
2.	On the CloudFormation console, choose Create Stack. 
3.	Choose the provided CloudFormation pipeline template. 
4.	Choose Next.
5.	Provide the stack parameters:
    *  Under FoDURL, provide Fortify On Demand URL, this will change region wise.
    *	Under FoDTenant, provide your tenant code. 
    *	Under FoDUser, provide the Fortify On Demand username.
    *	Under FoDPAT, provide the Fortify On Demand personal access token.
    *	Under FoDReleaseID, provide the Fortify On Demand application release Id. This could be given after the release is created in FoD portal.
    *	Under RepositoryName, enter CodeCommit repo name.
    *	Under Branch, enter name of the CodeCommit repo branch. This could be 'main' or 'master'.
