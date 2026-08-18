#!/usr/bin/env bash

set -euo pipefail

if [ "$#" -ne 1 ]; then
  echo "Usage: $0 BACKUP_FILE"
  exit 1
fi

BACKUP_FILE="$1"
TEST_DATABASE="thinkz_ai_restore_test"

if [ ! -s "$BACKUP_FILE" ]; then
  echo "ERROR: Backup file is missing or empty"
  exit 1
fi

echo "Removing only the previous restore-test database..."

docker exec thinkz_mongodb \
  mongosh --quiet \
  --eval "db.getSiblingDB('${TEST_DATABASE}').dropDatabase()"

echo "Restoring backup into ${TEST_DATABASE}..."

docker exec -i thinkz_mongodb \
  mongorestore \
  --archive \
  --gzip \
  --nsFrom='thinkz_ai.*' \
  --nsTo='thinkz_ai_restore_test.*' \
  < "$BACKUP_FILE"

echo "MongoDB restore test completed successfully."
