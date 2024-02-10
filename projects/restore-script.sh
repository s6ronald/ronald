#!/bin/bash

# Load database credentials
DB_HOST='postgres-service'  
DB_PORT='5432'
DB_NAME='s6ronald'
DB_USER='s6ronald'
DB_PASSWORD='s6ronald'

# Download the backup file from S3
aws s3 cp "s3://$BUCKET_NAME/backup_20240207_195414.dump.gz" /bk/backup_file.backup.gz

# Unzip the downloaded backup file
gunzip /bk/backup_file.backup.gz

# Restore the backup to the s6ronald database
pg_restore -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -v /bk/backup_file.backup.gz

# Optionally, remove the local backup file to save space
rm -f /bk/backup_file.backup.gz


