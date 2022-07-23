# k8s cronjob for postgres backup
Kubernetes CronJob to perform Postgres database backups. 

## Requirements
- We need to have [kubeseal](https://github.com/bitnami-labs/sealed-secrets) operator installed.

## TODO
- [X] List all database
- [X] excludes databases: 
  - template* 
  - rdsadmin
- [X] Backup database.
- [X] Zip backup database.
- [X] Upload backup to AWS S3