#!/bin/bash
# Script for restore PostgreSQL from Google Cloud Storage bucket

set -e

function show_help
{
echo '''
List and description of environment variables need to set:

PGPASSWORD - password for access a database
PGUSER - PostgreSQL user
PGHOST - PostgreSQL server address
PGPORT - PostgreSQL server port
BUCKET - Google Storage bucket for store backups
PGDATABASE - database for backup
DUMP - filename of dump in bucket
DROP - Drop schema 'public' and everything in it in database. Set exactly to "yes" for use it.

Optional:
CREDENTIALS - path to credentials json file.
'''
}

# Show help if need
if [[ $1 = "help" ]] || [[ $1 = "--help" ]] || [[ $1 = "-h" ]]; then
	echo '''
For run script, you need to mount json key file with credentials for your service account to /credentials/credentials.json'''
	show_help
	exit 0
fi

# Validate variables
if [ -z ${PGPASSWORD+x} ] || [ -z ${PGUSER+x} ] || [ -z ${PGHOST+x} ] || [ -z ${BUCKET} ] || [ -z ${PGDATABASE} ] || [ -z ${DUMP} ]; then
        show_help
        exit 1
fi

if [ -z ${CREDENTIALS+x} ]; then
        CREDENTIALS="./credentials.json"
fi

# Basic validation of credentials
if [ ! -f "$CREDENTIALS" ]; then
        echo "Credentials not mounted. Run with --help to read how to use."
        exit 1
fi

# Set port
if [ -z ${PGPORT+x} ]; then
        PGPORT=5432
fi

# Login to GCE
if ! gcloud auth activate-service-account --key-file $CREDENTIALS; then
	exit 1
fi

# Set variables
echo "Download dump $DUMP from $BUCKET"

gsutil cp gs://$BUCKET/$DUMP $DUMP
s
# Drop database before restore
if [[ $DROP = "yes" ]]; then
	psql -U $PGUSER -h $PGHOST -d $PGDATABASE -c "drop schema public cascade; create schema public;"
fi

#TODO detect zip and if so run zcat, otherwise cat if plain sql

# Dumping database
zcat $DUMP | psql -U $PGUSER -h $PGHOST -d $PGDATABASE
