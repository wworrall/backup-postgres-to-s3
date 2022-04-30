#!/bin/bash

set -e;

TIMESTAMP=$(date +%F_%T | tr ':' '-');

echo "Starting backup at $TIMESTAMP";

TEMP_FILE=$(mktemp tmp.XXXXXXXXXX);
S3_FILE="s3://$BUCKET_NAME/$DUMP_PREFIX-$TIMESTAMP.dump";

pg_dump -Fc --no-acl > $TEMP_FILE;
aws s3 mv $TEMP_FILE $S3_FILE $S3_MV_CMD_OPTIONS;

TIMESTAMP=$(date +%F_%T | tr ':' '-');

echo "Backup complete at $TIMESTAMP - uploaded $S3_FILE to S3";
