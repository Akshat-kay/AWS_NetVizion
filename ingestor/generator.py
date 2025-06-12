import boto3
import json
import random
import time

kinesis = boto3.client("kinesis", region_name="us-east-1")  # Use your region
STREAM_NAME = "netvizion-stream"  # Must match your Terraform name

def generate_record():
    return {
        "src_ip": f"192.168.1.{random.randint(1, 254)}",
        "dst_ip": f"10.0.0.{random.randint(1, 254)}",
        "bytes": random.randint(100, 10000),
        "timestamp": int(time.time())
    }

def main():
    while True:
        record = generate_record()
        print("Sending:", record)
        kinesis.put_record(
            StreamName=STREAM_NAME,
            Data=json.dumps(record),
            PartitionKey=record['src_ip']
        )
        time.sleep(2)  # adjustable interval

if __name__ == "__main__":
    main()
