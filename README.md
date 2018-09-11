# postgres-gce
Automation for Postgres in Google Cloud

## Build

```
docker build . -t pgrestore
```

## Example usage

```
docker run  \
-e "PGPASSWORD=mysecretpassword" -e "PGUSER=postgres" \
-e "PGHOST=localhost" -e "BUCKET=myawesomebucket" -e "PGDATABASE=postgres" \
-e "PGPORT=5432" -e "DUMP=mybackup." -i pgrestore restore
```
