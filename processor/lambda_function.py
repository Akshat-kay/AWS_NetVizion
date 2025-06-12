import boto3
import base64
import json
from datetime import datetime

timestream = boto3.client('timestream-write')

DATABASE_NAME = "netvizion_db"
TABLE_NAME = "netvizion_table"

def lambda_handler(event, context):
    records = []

    for record in event['Records']:
        payload = base64.b64decode(record['kinesis']['data']).decode('utf-8')
        data = json.loads(payload)

        # Enrichment: add simulated metadata
        data['region'] = 'us-east-1'
        data['service'] = 'ec2'

        records.append({
            'Dimensions': [
                {'Name': 'region', 'Value': data['region']},
                {'Name': 'service', 'Value': data['service']}
            ],
            'MeasureName': 'bytes_transferred',
            'MeasureValue': str(data['bytes']),
            'MeasureValueType': 'BIGINT',
            'Time': str(int(datetime.utcnow().timestamp() * 1000))
        })

    try:
        timestream.write_records(
            DatabaseName=DATABASE_NAME,
            TableName=TABLE_NAME,
            Records=records
        )
        return {
            'statusCode': 200,
            'body': f'Wrote {len(records)} records.'
        }
    except Exception as e:
        print("Write error:", e)
        return {
            'statusCode': 500,
            'body': str(e)
        }
