"""
Imports finding in Security Hub and upload the reports to S3 
Copyright OpenText. All Rights Reserved.
SPDX-License-Identifier: MIT-0
"""

import os
import json
import logging
import boto3
import datetime
import re

logger = logging.getLogger()
logger.setLevel(logging.DEBUG)

def send_finding_security_hub(allVulList):
    # local parameters
    PRODUCT_TITLE = "Fortify SAST"
    COMPANY_NAME = "OpenText"

    # import sechub + sts boto3 client
    securityhub = boto3.client('securityhub')
    sts = boto3.client('sts')    
    
    # retrieve account id from STS GetCallerID
    getAccount = sts.get_caller_identity()
    awsAccount = str(getAccount['Account'])
    awsRegion = os.environ['AWS_REGION']
    
    logger.info("updating vulnerabilities into SecurityHub")
    #logger.info(allVulList)
    if (len(allVulList) <= 0):
        logger.error("No vulnerabilities to add")
    for vul in allVulList:
        # create ISO 8601 timestamp
        iso8601Time = datetime.datetime.utcnow().replace(tzinfo=datetime.timezone.utc).isoformat()
        if "all_data" in vul: 
            normilizedRecommendation=remove_html_tags(vul['all_data']['recommendations']['recommendations'])
            sDesc=remove_html_tags(vul['all_data']['details']['summary'])
        else:
            normilizedRecommendation=remove_html_tags(vul['details']['recommendation'])
            sDesc=remove_html_tags(vul['details']['brief'])
        
        if "release" in vul:
            sAppName=vul['release']['applicationName']
            sAppVersion=vul['release']['releaseName']
        else:
            sAppName=vul['applicationVersion']['project']['name']
            sAppVersion=vul['applicationVersion']['name']
        
        if "friority" in vul:
            friority = str(vul['friority']).upper()
        else:
            friority = str(vul['severityString']).upper()
            
        # map Trivy severity to ASFF severity
        if friority == "LOW":
            fortifySev = int(1)
            fortifyAsffRating = fortifySev * 10
        elif friority == "MEDIUM":
            fortifySev = int(4)
            fortifyAsffRating = fortifySev * 10
        elif friority == "HIGH":
            fortifySev = int(7)
            fortifyAsffRating = fortifySev * 10
        elif friority == "CRITICAL":
            fortifySev = int(9)
            fortifyAsffRating = fortifySev * 10
        else:
            logger.error("No vulnerability severity information found")
        try:
            if "projectVersionId" in vul:
                vulId = str(vul['projectVersionId']) + "-" + str(vul['id'])
                sReleaseId=str(vul['projectVersionId'])
            else:
                vulId = str(vul['releaseId']) + "-" + str(vul['id'])
                sReleaseId=str(vul['releaseId'])
            
            if "issueName" in vul:
                catName = vul['issueName']
            else:
                catName = vul['category']
                
            if "issueInstanceId" in vul:
                sInstId = vul['issueInstanceId']
            else:
                sInstId = vul['instanceId']
            
            if "primaryLocationFull" in vul:
                sPrimeLocation=vul['primaryLocationFull']
            else:
                sPrimeLocation=vul['primaryLocation']
                
            response = securityhub.batch_import_findings(
                Findings=[
                    {
                        'SchemaVersion': '2018-10-08',
                        'Id': vulId,
                        'ProductArn': "arn:aws:securityhub:"+ awsRegion +":" + awsAccount +":product/" + awsAccount +"/default", 
                        "ProductName": PRODUCT_TITLE,
                        'GeneratorId': "arn:aws:securityhub:"+ awsRegion +":" + awsAccount +":product/" + awsAccount +"/default",
                        "CompanyName": COMPANY_NAME,
                        'AwsAccountId': awsAccount,
                        'Types': [ 'Software and Configuration Checks/Vulnerabilities/CVE' ],
                        'CreatedAt': iso8601Time,
                        'UpdatedAt': iso8601Time,
                        'Severity': {
                            'Original': friority,
                            'Normalized': fortifyAsffRating
                        },
                        'Title': catName,
                        'Description': sDesc,
                        'Remediation': {
                            'Recommendation': {
                                'Text': (normilizedRecommendation[:510] + '..') if len(normilizedRecommendation) > 510 else normilizedRecommendation,
                                'Url': vul['deepLink']
                            }
                        },
                        'ProductFields': { 
                            'Product Name': PRODUCT_TITLE, 
                            'aws/securityhub/CompanyName': COMPANY_NAME,
                            'aws/securityhub/ProductName': PRODUCT_TITLE
                        },
                        'Resources': [
                            {
                                'Type': 'Application',
                                'Id': vulId,
                                'Partition': 'aws',
                                'Region': awsRegion,
                                'Details': {
                                    'Other': {
                                        'APPLICATION ': sReleaseId,
                                        'APPLICATION NAME': sAppName,
                                        'APPLICATION VERSION': sAppVersion,
                                        'PRIMARY LOCATION': sPrimeLocation,
                                        'LINE NUMBER': str(vul['lineNumber']),
                                        'INSTANCE ID': sInstId
                                    }
                                }
                            },
                        ],
                        'RecordState': 'ACTIVE'
                    }
                ]
            )
            print(response)
        except Exception as e:
            print(e)
            raise

def process_message(event):
    # processing json
    out_index = 0
    vullist = []
    for vul in event['vulnerabilities']:
        isDebricked = 0
        if "all_data" in vul:
            if str(vul['all_data']['details']['analyzerName']).lower() == "debricked":
                isDebricked = 1
                
        if isDebricked == 0:
            vullist.append(vul)
            
        if len(vullist) == 90:
            #adding vulnerabilities to Security Hub
            send_finding_security_hub(vullist)
            vullist = []
            out_index += 1

    # dump the last batch
    if len(vullist) > 0:
        #adding vulnerabilities to Security Hub
        send_finding_security_hub(vullist)        
    
def lambda_handler(event, context):
    # Lambda entrypoint 
    try:
        logger.info("Starting function...")
        parsed_json = parse_json(event)
        return process_message(parsed_json)
    except Exception as error:
        logger.error("Error {}".format(error))
        raise

def remove_html_tags(text):
    # Remove html tags from a string
    clean = re.compile('<.*?>')
    return re.sub(clean, '', text)

def parse_json(event):
    # parsing json
    try:
        d1 = json.dumps(event)
        json_data = json.loads(d1)
        return json_data
    except Exception as err:
        logger.error("Error parsing json: {}".format(err))
        raise
    