#!/bin/bash
set -e

# Update system
yum update -y

# Install Python and dependencies
yum install -y python3 python3-pip
pip3 install flask psycopg2-binary

# Fetch SSM parameters
DB_HOST=$(aws ssm get-parameter --name "/flask-rds-platform/db_host" --query "Parameter.Value" --output text)
DB_NAME=$(aws ssm get-parameter --name "/flask-rds-platform/db_name" --query "Parameter.Value" --output text)
DB_USER=$(aws ssm get-parameter --name "/flask-rds-platform/db_username" --query "Parameter.Value" --output text)
DB_PORT=$(aws ssm get-parameter --name "/flask-rds-platform/db_port" --query "Parameter.Value" --output text)
DB_PASSWORD=$(aws ssm get-parameter --name "/flask-rds-platform/db_password" --query "Parameter.Value" --with-decryption --output text)

# Export environment variables
export DB_HOST DB_NAME DB_USER DB_PORT DB_PASSWORD

# Pull app.py from S3
aws s3 cp s3://flask-rds-s3-bucket/app.py /home/ec2-user/app.py

# Start Flask
cd /home/ec2-user
nohup python3 app.py &