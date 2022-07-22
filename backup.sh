#!/bin/bash
#---------------------#
# Backups:            #
#   * Postgresql      #
# Date: Julio/2022    #
# Version: 1.0        #
# Autor: J. Andres B. #
#---------------------#

# Execute on current path
cd "$(dirname "$0")"

# required enviroment variables:
required=(
  PGUSER
  PGPASSWORD
  PGHOST
  PGDATABASE
  S3_BUCKET
  AWS_ACCESS_KEY_ID
  AWS_SECRET_ACCESS_KEY
  AWS_DEFAULT_REGION
)

for v in "${required[@]}"; do
  if [[ -z "${!v}" ]]; then
      echo "Required env var $v not set!"
      exit 1
  fi
done

# Variables
DATE="$(date +%Y-%m-%d)"
DBS=$(psql -d $PGDATABASE -l -t | cut -d'|' -f1 | sed -e 's/ //g' -e '/^$/d' | grep -v template | grep -v rdsadmin)

# Backing up databases
for db in $DBS; do
    echo "Backing up $db"
    pg_dump -Fc -f $db.dump $db
    echo "Compressing $db"
    gzip /backup/$db.dump
done

# Uploading to S3
for db in $DBS; do
    echo "Uploading $db"
    aws s3 cp $db.dump.gz s3://$S3_BUCKET/$db/$DATE.dump.gz
done

echo "Backups completed"