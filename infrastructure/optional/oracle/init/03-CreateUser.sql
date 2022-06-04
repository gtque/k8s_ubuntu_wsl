
CREATE USER devuser1 IDENTIFIED BY devpw
    DEFAULT TABLESPACE dev_data
    TEMPORARY TABLESPACE temp
    ACCOUNT UNLOCK;

/* Standard 4x schema perms */
ALTER USER devuser1 QUOTA UNLIMITED ON dev_data;
GRANT CONNECT TO devuser1;
GRANT SELECT_CATALOG_ROLE TO devuser1;
GRANT LOCALDEV TO devuser1;
GRANT CREATE ANY DIRECTORY TO devuser1;
GRANT FORCE ANY TRANSACTION TO devuser1;
GRANT CREATE DATABASE LINK TO devuser1;
GRANT CREATE SEQUENCE TO devuser1;
GRANT CREATE VIEW TO devuser1;
GRANT CREATE SYNONYM TO devuser1;
GRANT CREATE CLUSTER TO devuser1;
GRANT CREATE TABLE TO devuser1;
GRANT UNLIMITED TABLESPACE TO devuser1;
GRANT ALTER SESSION TO devuser1;
GRANT CREATE SESSION TO devuser1;
GRANT CREATE JOB TO devuser1;


/* Dev env additions */
GRANT DATAPUMP_EXP_FULL_DATABASE TO devuser1;
GRANT DATAPUMP_IMP_FULL_DATABASE TO devuser1;
GRANT EXP_FULL_DATABASE TO devuser1;
GRANT IMP_FULL_DATABASE TO devuser1;
GRANT LOCALDEV TO devuser1 WITH ADMIN OPTION;
ALTER USER devuser1 DEFAULT ROLE ALL;


exit;
