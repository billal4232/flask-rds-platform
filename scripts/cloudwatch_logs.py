import boto3

session = boto3.Session(profile_name="limonlab", region_name="eu-north-1")
logs_client = session.client("logs")

response = logs_client.filter_log_events(
    logGroupName='/flask-rds-platform/flask-logs',
    filterPattern='?ERROR ?WARNING ?CRITICAL',
    limit=50
)
for event in response['events']:
    print(event['message'])
    
if not response['events']:
    print("No errors or warnings found.")