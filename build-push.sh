#!/bin/bash

docker build . -t wworrall/backup-postgres-to-s3:15;
docker login --username=wworrall;
docker push wworrall/backup-postgres-to-s3:15;