import boto3
import os
import sys
import logging
import pymysql
import json
import requests
from requests.auth import HTTPBasicAuth
from botocore.exceptions import ClientError
from urllib.request import Request, urlopen
from urllib.error import URLError, HTTPError


region = os.environ['REGION']
secret_name = os.environ['SECRET_NAME']
rds_username = os.environ['SQL_USERNAME']
rds_password = os.environ['SQL_PASSWORD']
db_name = os.environ['DB_NAME']
rds_dns_name = os.environ['RDS_DNS_NAME']
slack_webhook = os.environ['SLACK_WEBHOOK']
slack_channel = os.environ['SLACK_CHANNEL']
jira_base_url = os.environ['JIRA_BASE_URL']
jira_user_email = os.environ['JIRA_USER_EMAIL']
jira_api_token = os.environ['JIRA_API_TOKEN']
jira_transition = os.environ['TRANSITION']
snow_svc_acc = os.environ['SNOW_SVC_ACC']
snow_svc_pwd = os.environ['SNOW_SVC_PWD']
snow_cr_ssm_path = os.environ['SNOW_CR_SSM_PATH']
snow_url = os.environ['SNOW_URL']


def update_snow_cr(snow_url, snow_svc_acc, snow_svc_pwd, sys_id):
    print("test")


def get_ssm_params(param_name, region, decrypt):
    session = boto3.session.Session()
    ssm_client = session.client(
        service_name='ssm',
        region_name=region,
    )

    try:
        param_value = ssm_client.get_parameter(
            Name=param_name,
            WithDecryption=decrypt
        )
        print(f'Parameter: {param_value}')
        return param_value['Parameter']['Value']
    except Exception as e:
        print('Error - reason "%s"' % str(e))
        sys.exit()


def update_jira_issue(jira_base_url, jira_issue, jira_user_email, jira_api_token, script_result, logger):
    try:
        jira_issue_url = f'{jira_base_url}/rest/api/3/issue/{jira_issue}/transitions'
        auth = HTTPBasicAuth(jira_user_email, jira_api_token)

        headers = {
            "Accept": "application/json",
            "Content-Type": "application/json"
        }
        payload = json.dumps({
            "update": {"comment": [{"add": {"body": {"type": "doc", "version": 1, "content": [{
                "type": "paragraph",
                "content": [{"text": f"{script_result}", "type": "text"}]}]}}}]},
            "transition": {"id": "41"}
        })
        response = requests.request(
            "POST",
            jira_issue_url,
            data=payload,
            headers=headers,
            auth=auth
        )
        return response
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
        print('Error - reason "%s"' % str(e))
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)
        print('Error - reason "%s"' % str(e))


def get_secret(secret_name, region):
    session = boto3.session.Session()
    sm_client = session.client(
        service_name='secretsmanager',
        region_name=region,
    )

    try:
        secret_value = sm_client.get_secret_value(
            SecretId=secret_name
        )
        print(f'Secrets: {secret_value}')
        secrets_json = json.loads(secret_value['SecretString'])
        return secrets_json
    except Exception as e:
        print('Error - reason "%s"' % str(e))
        sys.exit()


def mysql_connect(rds_host, rds_user, rds_pwd, db_name, script):
    logger = logging.getLogger()
    logger.setLevel(logging.INFO)

    try:
        conn = pymysql.connect(rds_host, user=rds_user,
                               passwd=rds_pwd, db=db_name, connect_timeout=5)

        with conn.cursor() as cur:
            cur.execute(script)

        result = dict()
        result['Rows'] = cur.rowcount
        result['Output'] = cur.fetchall()
        return result

    except pymysql.MySQLError as e:
        logger.error(e)
        sys.exit()

    finally:
        conn.close()

    logger.info("SUCCESS: Connection to RDS MySQL instance succeeded")


def download_s3_object(bucket, key):
    try:
        s3_resource = boto3.resource('s3')
        s3_resource.meta.client.download_file(
            bucket, key, '/tmp/run-me.sql')

        # return no response
    except Exception as e:
        print('Error - reason "%s"' % str(e))
        sys.exit()


def lambda_handler(event, context):

    detail = event['detail']
    logger = logging.getLogger()
    # Check that we actually got something from CW
    if not detail['responseElements']:
        print('No responseElements found')
        if detail['errorCode']:
            print('errorCode: ' + detail['errorCode'])
        if detail['errorMessage']:
            print('errorMessage: ' + detail['errorMessage'])
        return False

    # Get the S3 object arn - calculate the Jira Issue Number
    try:
        s3_file_arn = event['detail']['resources'][0]['ARN']
        bucket = event['detail']['requestParameters']['bucketName']
        key = event['detail']['requestParameters']['key']
        print(f'Object arn: {s3_file_arn}')
        print(f'Bucket: {bucket}')
        print(f'File: {key}')
        # There's no output so we don't need a response
        download_s3_object(bucket, key)

        # Derive the Jira Issue id
        key_parts = key.split('-')
        jira_issue = f"{key_parts[0]}-{key_parts[1]}"

    except Exception as e:
        print('Error - reason "%s"' % str(e))

    # Get the data we need from SSM
    try:
        snow_cr_ssm_path_sys_id = f'{snow_cr_ssm_path}/{jira_issue}'

        rds_user = get_ssm_params(rds_username, region, True)
        rds_pwd = get_ssm_params(rds_password, region, True)
        rds_host = get_ssm_params(rds_dns_name, region, True)
        slack_webhook_url = get_ssm_params(slack_webhook, region, True)
        snow_cr_sys_id = get_ssm_params(snow_cr_ssm_path_sys_id, region, False)
        print(f'RDS User param: {rds_user}')
        print(f'RDS Host param: {rds_host}')
        print(f'Slack param: {slack_webhook_url}')
        print(f'SNOW CR Sys_Id: {snow_cr_sys_id}')

    except Exception as e:
        print('Error - reason "%s"' % str(e))

    # # Or we can use Secrets Manager
    # try:
    #     secrets = get_secret(secret_name, region)
    #     print('SM - Username: {0}'.format(secrets['username']))
    #     # print('Secret: RDS Username: {0}'.format(secrets['username']))
    # except Exception as e:
    #     print('Error - reason "%s"' % str(e))

    # Connect to RDS and run the script
    try:
        script = open('/tmp/run-me.sql', 'r').read()
        script_result = mysql_connect(
            rds_host, rds_user, rds_pwd, db_name, script)
        print(f'Script output: {script_result}')
    except Exception as e:
        print('Error - reason "%s"' % str(e))

    # Send result to Slack
    try:
        slack_message = {
            'channel': slack_channel,
            'text': f'Result from {key}: {script_result}',
        }
        response = requests.post(slack_webhook_url, json=slack_message)
        logger.info("Message posted to %s", slack_message['channel'])
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
        print('Error - reason "%s"' % str(e))
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)
        print('Error - reason "%s"' % str(e))

    # Update Jira Issue
    # Add some logic to catch non-200 codes. Code below doesn't error on 400 f.e.
    try:
        response = update_jira_issue(
            jira_base_url, jira_issue, jira_user_email, jira_api_token, script_result, logger)

        logger.info("Message posted to %s", jira_issue)
        logger.info("Jira response to %s", response)
    except HTTPError as e:
        logger.error("Request failed: %d %s", e.code, e.reason)
        print('Error - reason "%s"' % str(e))
    except URLError as e:
        logger.error("Server connection failed: %s", e.reason)
        print('Error - reason "%s"' % str(e))

    # Update SNOW Ticket & Set to PIR
    try:
        # WIP - this doesn't do anything yet.
        update_snow_cr

    except Exception as e:
        print('Error - reason "%s"' % str(e))
