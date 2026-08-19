#!/usr/bin/env bash

set -euo pipefail
umask 077

BACKUP_DIRECTORY="/opt/thinkz-ai/backups"
TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"
BACKUP_FILE="${BACKUP_DIRECTORY}/thinkz_ai_${TIMESTAMP}.archive.gz"

S3_BUCKET="thinkz-ai-rk-backups-114757333589"
S3_PREFIX="mongodb-backups"
AWS_REGION="ap-south-2"

mkdir -p "$BACKUP_DIRECTORY"

if ! command -v docker >/dev/null 2>&1; then
  echo "ERROR: Docker is unavailable"
  exit 1
fi

if ! command -v aws >/dev/null 2>&1; then
  echo "ERROR: AWS CLI is unavailable"
  exit 1
fi

docker exec thinkz_mongodb \
  mongodump \
  --db thinkz_ai \
  --archive \
  --gzip > "$BACKUP_FILE"

if [ ! -s "$BACKUP_FILE" ]; then
  echo "ERROR: MongoDB backup is empty"
  exit 1
fi

echo "Local backup completed: $BACKUP_FILE"

aws s3 cp \
  "$BACKUP_FILE" \
  "s3://${S3_BUCKET}/${S3_PREFIX}/" \
  --region "$AWS_REGION"

echo "S3 upload completed."

find "$BACKUP_DIRECTORY" \
  -maxdepth 1 \
  -type f \
  -name "thinkz_ai_*.archive.gz" \
  -mtime +7 \
  -delete

echo "MongoDB backup workflow completed successfully."
