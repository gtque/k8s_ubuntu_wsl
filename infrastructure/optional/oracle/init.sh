#!/bin/bash
echo "copying db_init sql files."
kubectl -n infrastructure cp /usr/local/bin/wsl-local-k8s/infrastructure/optional/oracle/init/ oracle-0:/tmp
echo "creating import dir"
kubectl -n infrastructure exec -i oracle-0 -- mkdir /opt/oracle/oradata/import
echo "setting up dev data tables"
kubectl -n infrastructure exec -i oracle-0 -- sqlplus sys/password as sysdba @/tmp/db_init/01-CreateDevDataTablespace.sql
echo "initializing db"
kubectl -n infrastructure exec -i oracle-0 -- sqlplus sys/password as sysdba @/tmp/db_init/02-initdb.sql
echo "creating devuser1"
kubectl -n infrastructure exec -i oracle-0 -- sqlplus sys/password as sysdba @/tmp/db_init/03-CreateUser.sql
