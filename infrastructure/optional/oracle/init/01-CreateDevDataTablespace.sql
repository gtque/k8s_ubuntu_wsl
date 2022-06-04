CREATE DIRECTORY DATA_DUMP_DIR AS '/opt/oracle/oradata/import';

CREATE TABLESPACE dev_data
    DATAFILE '/opt/oracle/oradata/devdata.dbf' SIZE 500M AUTOEXTEND ON MAXSIZE unlimited;

exit;
