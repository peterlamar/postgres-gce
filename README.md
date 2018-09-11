# postgres-gce
Automation for Postgres in Google Cloud

## Build

```
docker build . -t pgrestore
```

Credentials are grabbed from a local credentials.json file in the root of the
project.

## Example usage

List and description of environment variables need to set:

PGPASSWORD - password for access a database
PGUSER - PostgreSQL user
PGHOST - PostgreSQL server address
PGPORT - PostgreSQL server port
BUCKET - Google Storage bucket for store backups
PGDATABASE - database for backup
DUMP - filename of dump in bucket
DROP - Drop schema 'public' and everything in it in database. Set to "yes" to
use it.

```
docker run  \
-e "PGPASSWORD=mysecretpassword" -e "PGUSER=postgres" \
-e "PGHOST=localhost" -e "BUCKET=myawesomebucket" -e "PGDATABASE=postgres" \
-e "PGPORT=5432" -e "DUMP=mybackup." "DROP=yes" -i pgrestore restore
```
