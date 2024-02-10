#!/bin/bash

# Load database credentials from secret
DB_HOST=$(cat /db-credentials-secret/DB_HOST)
DB_PORT=$(cat /db-credentials-secret/DB_PORT)
DB_NAME=$(cat /db-credentials-secret/DB_NAME)
DB_USER=$(cat /db-credentials-secret/DB_USER)
DB_PASSWORD=$(cat /db-credentials-secret/DB_PASSWORD)

# Backup parameters
BACKUP_DIR="/az"
BACKUP_FILENAME="backup_$(date +\%Y\%m\%d_\%H\%M\%S).dump"  # Change the extension to match the format
BACKUP_FILE="$BACKUP_DIR/$BACKUP_FILENAME"

# Set the password for pg_dump
export PGPASSWORD="$DB_PASSWORD"

# Perform database backup with custom format
pg_dump -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -w -F c -f "$BACKUP_FILE"

# Optionally, compress the backup file
gzip "$BACKUP_FILE"

# AWS S3 parameters
AWS_S3_BUCKET="$BUCKET_NAME"  # Replace with your S3 bucket name
AWS_S3_PATH="$AWS_S3_BUCKET/$BACKUP_FILENAME.gz"


# Copy the backup to AWS S3
aws s3 cp "$BACKUP_FILE.gz" "s3://$AWS_S3_PATH"

# Optionally, remove the local backup file to save space
rm -f "$BACKUP_FILE.gz"
