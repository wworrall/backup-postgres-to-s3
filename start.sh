#!/bin/bash

set -e;

if [ -z "$CRON_SCHEDULE" ]; then
   >&2 echo "CRON_SCHEDULE not set";
   exit 1;
fi

# extract environment variables for cron
printenv | sed 's/^\(.*\)=\(.*\)$/export \1="\2"/g' > /app/env.sh

echo "\
PATH=/app:$PATH
SHELL=/bin/bash
BASH_ENV=/app/env.sh
$CRON_SCHEDULE /app/run-backup.sh 2>&1 | tee -a /var/log/cron.log
" > /app/backup-cron;

# make the cron job executable
chmod 0644 /app/backup-cron;

# apply cron job
crontab /app/backup-cron;

cron && tail -f /var/log/cron.log;