# Backup Postgres to S3

Backup a Postgres Database to Amazon S3 (or S3 compatible storage provider) using `pg_dump` and AWS CLI utility (`aws s3 mv`).

Currently only supports PostgreSQL Client 14.

Homepage: https://github.com/wworrall/backup-postgres-to-s3

## Usage

### Environment variables

Environment variables in `run-backup.sh` script:

- `BUCKET_NAME`
- `DUMP_PREFIX`
- `S3_MV_CMD_OPTIONS` (optional)

Environment variables required for `aws s3` command:

- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

Environment variables for `pg_dump`:

- `PGPASSWORD` (required)
- `PGDATABASE`
- `PGHOST`
- `PGOPTIONS`
- `PGPORT`
- `PGUSER`

See https://www.postgresql.org/docs/current/app-pgdump.html and https://awscli.amazonaws.com/v2/documentation/api/latest/reference/s3/mv.html for more options.

### Direct

Download

```console
curl https://raw.githubusercontent.com/wworrall/backup-postgres-to-s3/master/run-backup.sh > /usr/local/bin/backup-postgres-to-s3;
```

Make executable

```console
chmod +x /usr/local/bin/backup-postgres-to-s3;
```

#### Run periodically as cron job

Create crontab file e.g.:

```cron
PATH=$PATH # ensure to add your path so that `pg_dump` and `aws` are accessible
SHELL=/bin/bash # use bash shell
BASH_ENV=~/backup-postgres-to-s3-env.sh # e.g. export BUCKET_NAME=my-bucket ....
0 0 * * 0 /usr/local/bin/backup-postgres-to-s3 # every sunday night
```

Make executable:

```console
chmod +x ~/backup-postgres-to-s3.crontab
```

Apply crontab e.g.:

```console
crontab ~/backup-postgres-to-s3.crontab
```

### Docker Image (recommended)

```console
docker run -d \
  --env CRON_SCHEDULE="0 0 * * 0" \
  --env BUCKET_NAME=my-bucket \
  --env DUMP_PREFIX=my_db_backup \
  --env PGHOST=localhost \
  --env PGUSER=postgres \
  --env PGPASSWORD=postgres \
  --env PGDATABASE=my_db
  --env AWS_ACCESS_KEY_ID=awsaccesskeyid \
  --env AWS_SECRET_ACCESS_KEY=awssecretaccesskey \
  --env AWS_DEFAULT_REGION=us-east-1 \
  wworrall/backup-postgres-to-s3
```

# Acknowledgements

Inspired by Sambhav Jain's article https://dev.to/sambhav2612/backup-postgres-to-s3-2nkk and Eric Burger's article https://levelup.gitconnected.com/cron-docker-the-easiest-job-scheduler-youll-ever-create-e1753eb5ea44.

## Contributing

If you have any suggestions please open up an issue.

## License

[MIT License](http://opensource.org/licenses/MIT)
