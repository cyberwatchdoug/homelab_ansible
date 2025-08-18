#!/bin/bash

# This script removes old paperless backup files older than 7 days
BACKUP_DIR="/srv/dev-disk-by-uuid-54b8eb26-f303-4324-9aaf-983985e9157f/omv_data/paperless-backup"
RETENTION_DAYS="${1:-7}"

logger -t paperless-backup-retention "Script started. Retention: $RETENTION_DAYS days. Directory: $BACKUP_DIR"

if [ ! -d "$BACKUP_DIR" ]; then
  logger -t paperless-backup-retention "Backup directory $BACKUP_DIR does not exist."
  exit 1
fi

cd "$BACKUP_DIR" || exit 1

FILES_FOUND=$(find "$BACKUP_DIR" -type f -name 'paperless-backup-*.zip.gpg' -mtime +"$RETENTION_DAYS")
if [ -z "$FILES_FOUND" ]; then
  logger -t paperless-backup-retention "No files older than $RETENTION_DAYS days found."
else
  find "$BACKUP_DIR" -type f -name 'paperless-backup-*.zip.gpg' -mtime +"$RETENTION_DAYS" -print -exec sh -c 'logger -t paperless-backup-retention "Deleting $1"; rm -f "$1"' _ {} \;
fi

logger -t paperless-backup-retention "Script finished."