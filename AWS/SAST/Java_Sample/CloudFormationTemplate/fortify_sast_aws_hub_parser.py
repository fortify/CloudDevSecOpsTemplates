"""
Imports finding in Security Hub 
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
    logger.info("pushing...")
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
        try:
            vul['AwsAccountId'] = awsAccount
            #vul['Types'] = ['Software and Configuration Checks/Vulnerabilities/CVE']
            #vul['ProductArn'] = "arn:aws:securityhub:"+ awsRegion +":" + awsAccount +":product/"+ awsAccount +"/default"
            #vul['GeneratorId'] = "arn:aws:securityhub:"+ awsRegion +":" + awsAccount +":product/"+ awsAccount +"/default"
            #vul['Resources']['Region'] = awsRegion
            #vul['CreatedAt'] = datetime.datetime.utcnow().replace(tzinfo=datetime.timezone.utc).isoformat()
            vul['UpdatedAt'] = datetime.datetime.utcnow().replace(tzinfo=datetime.timezone.utc).isoformat()
            #print(vul)
        except Exception as e:
            print(e)
            raise
    response = securityhub.batch_import_findings(Findings=allVulList)


def process_message(event):
    # processing json
    out_index = 0
    vullist = []
    logger.info(event)
    for vul in event['issues']:
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

def parse_json(event):
    # parsing json
    try:
        logger.info("parsing...")
        d1 = json.dumps(event)
        json_data = json.loads(d1)
        #json_data['Details'] = json_data.pop('details')
        return json_data
    except Exception as err:
        logger.error("Error parsing json: {}".format(err))
        raise
        