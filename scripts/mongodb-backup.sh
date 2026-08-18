#!/usr/bin/env bash

set -euo pipefail
umask 077
BACKUP_DIRECTORY="/opt/thinkz-ai/backups"
TIMESTAMP="$(date +%Y-%m-%d_%H-%M-%S)"
BACKUP_FILE="${BACKUP_DIRECTORY}/thinkz_ai_${TIMESTAMP}.archive.gz"

mkdir -p "$BACKUP_DIRECTORY"

docker exec thinkz_mongodb \
  mongodump \
  --db thinkz_ai \
  --archive \
  --gzip > "$BACKUP_FILE"

if [ ! -s "$BACKUP_FILE" ]; then
  echo "ERROR: MongoDB backup is empty"
  exit 1
fi

find "$BACKUP_DIRECTORY" \
  -maxdepth 1 \
  -type f \
  -name "thinkz_ai_*.archive.gz" \
  -mtime +7 \
  -delete

echo "MongoDB backup completed: $BACKUP_FILE"
